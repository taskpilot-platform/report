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
  "asset/assets/diagrams/ch3_03_interaction_overview.svg",
  "asset/assets/diagrams/ch3_09_auth_authorization_overview.svg",
  "asset/assets/diagrams/ch3_10_realtime_notification_overview.svg",
  "asset/assets/diagrams/ch3_10_onesignal_push_flow.svg",
  "asset/assets/diagrams/ch3_11_ai_copilot_architecture.svg",
  "asset/assets/diagrams/ch3_11_auto_fallback.svg",
  "asset/assets/diagrams/ch3_11_smart_routing.svg",
  "asset/assets/diagrams/ch3_11_tool_registry.svg",
  "asset/assets/diagrams/ch3_12_assignment_recommendation_process.svg",
  "asset/assets/diagrams/ch3_13_deployment_architecture.svg",
  "asset/assets/diagrams/ch3_13_external_connection_flow.svg",
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
