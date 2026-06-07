import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";
import { createRequire } from "node:module";

const workspace = path.resolve(import.meta.dirname, "..", "..", "..");
const root = path.join(workspace, "report", "_incoming");
const requireFromFrontend = createRequire(path.join(workspace, "taskpilot-frontend", "package.json"));
const puppeteer = requireFromFrontend("puppeteer");
const chromeCacheDir = path.join(process.env.HOME ?? "", ".cache", "puppeteer", "chrome");

const files = [
  "asset/chapter2/ch2_01_agile_scrum.svg",
  "asset/chapter2/ch2_02_scrum_sprint.svg",
  "asset/chapter2/ch2_03_kanban.svg",
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
  "asset/chapter2/ch2_06_weighted_scoring_ahp.svg",
];

function findChromeExecutable() {
  if (!fs.existsSync(chromeCacheDir)) return undefined;
  const candidates = fs
    .readdirSync(chromeCacheDir)
    .sort()
    .reverse()
    .map((dir) => path.join(chromeCacheDir, dir, "chrome-linux64", "chrome"))
    .filter((file) => fs.existsSync(file));
  return candidates[0];
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

    const pngPath = svgPath.replace(/\.svg$/i, ".png");
    await page.goto(pathToFileURL(svgPath).href);
    const svg = await page.$("svg");
    const box = await svg.boundingBox();
    const width = Math.ceil(box.width);
    const height = Math.ceil(box.height);
    await page.setViewport({ width, height, deviceScaleFactor: 2 });
    await page.goto(pathToFileURL(svgPath).href);
    await page.screenshot({ path: pngPath, omitBackground: true });
    console.log(`Exported ${path.relative(root, pngPath)}`);
  }
} finally {
  await browser.close();
}
