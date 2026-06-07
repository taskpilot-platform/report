import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";
import { createRequire } from "node:module";

const workspace = path.resolve(import.meta.dirname, "..", "..", "..");
const root = path.join(workspace, "report", "_incoming");
const requireFromFrontend = createRequire(path.join(workspace, "taskpilot-frontend", "package.json"));
const puppeteer = requireFromFrontend("puppeteer");
const chromeCacheDir = path.join(process.env.HOME ?? "", ".cache", "puppeteer", "chrome");
const padding = 16;

const files = [
  "asset/chapter2/ch2_01_agile_scrum.svg",
  "asset/chapter2/ch2_02_scrum_sprint.svg",
  "asset/chapter2/ch2_03_kanban.svg",
  "asset/chapter2/ch2_06_weighted_scoring_ahp.svg",
  "asset/chapter2/ch2_07_modular_monolith.svg",
  "asset/assets/diagrams/ch3_01_asana_views.svg",
  "asset/assets/diagrams/ch3_01_jira_workflow.svg",
  "asset/assets/diagrams/ch3_01_trello_kanban.svg",
  "asset/assets/diagrams/ch3_02_analysis_design_process.svg",
  "asset/assets/diagrams/ch3_02_testing_deployment_process.svg",
  "asset/assets/diagrams/ch3_03_frontend_spa_architecture.svg",
  "asset/assets/diagrams/ch3_03_interaction_overview.svg",
  "asset/assets/diagrams/ch3_03_system_context.svg",
  "asset/assets/diagrams/ch3_06_backend_modular_monolith.svg",
  "asset/assets/diagrams/ch3_07_contracts_communication.svg",
  "asset/assets/diagrams/ch3_07_port_adapter_model.svg",
  "asset/assets/diagrams/ch3_08_flyway_change_management.svg",
  "asset/assets/diagrams/ch3_13_deployment_architecture.svg",
];

function findChromeExecutable() {
  if (!fs.existsSync(chromeCacheDir)) return undefined;
  return fs
    .readdirSync(chromeCacheDir)
    .sort()
    .reverse()
    .map((dir) => path.join(chromeCacheDir, dir, "chrome-linux64", "chrome"))
    .find((file) => fs.existsSync(file));
}

function formatNumber(value) {
  return Number(value.toFixed(2)).toString();
}

function updateSvgRoot(svg, viewBox) {
  return svg.replace(/<svg\b([^>]*)>/, (match, attrs) => {
    let next = attrs
      .replace(/\swidth="[^"]*"/, "")
      .replace(/\sheight="[^"]*"/, "")
      .replace(/\sviewBox="[^"]*"/, "")
      .replace(/max-width:\s*[^;"]+;?/g, `max-width: ${formatNumber(viewBox.width)}px;`);

    next = next.trimEnd();
    return `<svg${next} width="${formatNumber(viewBox.width)}" height="${formatNumber(viewBox.height)}" viewBox="${formatNumber(viewBox.x)} ${formatNumber(viewBox.y)} ${formatNumber(viewBox.width)} ${formatNumber(viewBox.height)}">`;
  });
}

const browser = await puppeteer.launch({
  headless: "new",
  executablePath: findChromeExecutable(),
  args: ["--no-sandbox", "--disable-setuid-sandbox"],
});

try {
  const page = await browser.newPage();
  for (const rel of files) {
    const svgPath = path.join(root, rel);
    if (!fs.existsSync(svgPath)) continue;

    await page.goto(pathToFileURL(svgPath).href);
    const box = await page.evaluate((pad) => {
      const svg = document.querySelector("svg");
      const ignoredTags = new Set(["defs", "style", "marker", "filter", "linearGradient", "stop"]);
      const boxes = [];

      for (const element of svg.querySelectorAll("*")) {
        if (ignoredTags.has(element.tagName)) continue;
        if (element.classList?.contains("canvas")) continue;
        if (element.closest("defs")) continue;

        try {
          const box = element.getBBox();
          if (box.width > 0 && box.height > 0) {
            boxes.push({
              x1: box.x,
              y1: box.y,
              x2: box.x + box.width,
              y2: box.y + box.height,
            });
          }
        } catch {
          // Some SVG elements do not expose a geometry box.
        }
      }

      if (!boxes.length) return null;

      const x1 = Math.min(...boxes.map((box) => box.x1)) - pad;
      const y1 = Math.min(...boxes.map((box) => box.y1)) - pad;
      const x2 = Math.max(...boxes.map((box) => box.x2)) + pad;
      const y2 = Math.max(...boxes.map((box) => box.y2)) + pad;

      return { x: x1, y: y1, width: x2 - x1, height: y2 - y1 };
    }, padding);

    if (!box) continue;

    const before = fs.readFileSync(svgPath, "utf8");
    const after = updateSvgRoot(before, box);
    fs.writeFileSync(svgPath, after, "utf8");
    console.log(`Cropped ${rel} -> ${formatNumber(box.width)}x${formatNumber(box.height)}`);
  }
} finally {
  await browser.close();
}
