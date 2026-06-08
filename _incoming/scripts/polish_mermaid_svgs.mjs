import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const dirs = [
  path.join(root, "asset", "chapter2"),
  path.join(root, "asset", "assets", "diagrams"),
];

const customSvgs = new Set([
  path.join(root, "asset", "chapter2", "ch2_07_modular_monolith.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_02_analysis_design_process.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_02_testing_deployment_process.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_03_frontend_spa_architecture.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_03_interaction_overview.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_03_system_context.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_06_backend_modular_monolith.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_08_flyway_change_management.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_13_deployment_architecture.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_11_ai_copilot_architecture.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_11_auto_fallback.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_11_smart_routing.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_11_tool_registry.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_12_assignment_recommendation_process.svg"),
  path.join(root, "asset", "assets", "diagrams", "ch3_13_external_connection_flow.svg"),
]);

function listSvgFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs
    .readdirSync(dir, { withFileTypes: true })
    .flatMap((entry) => {
      const file = path.join(dir, entry.name);
      if (entry.isDirectory()) return listSvgFiles(file);
      return entry.isFile() && entry.name.endsWith(".svg") ? [file] : [];
    });
}

let changed = 0;

for (const file of dirs.flatMap(listSvgFiles)) {
  if (customSvgs.has(file)) continue;

  const before = fs.readFileSync(file, "utf8");
  let after = before
    .replace(/\brx="5"\s+ry="5"/g, 'rx="16" ry="16"')
    .replace(/\brx="5"/g, 'rx="16"')
    .replace(/\bry="5"/g, 'ry="16"')
    .replace(/display:\s*table-cell;\s*(?:vertical-align:\s*middle;\s*)?/g, "display: flex; align-items: center; justify-content: center;")
    .replace(/display:\s*table;\s*(?:vertical-align:\s*middle;\s*)?/g, "display: flex; align-items: center; justify-content: center;")
    .replace(/text-align:\s*center;/g, "text-align: center;")
    .replace(/<div xmlns="http:\/\/www\.w3\.org\/1999\/xhtml" style="(?![^"]*box-sizing: border-box)/g, '<div xmlns="http://www.w3.org/1999/xhtml" style="width: 100%; height: 100%; box-sizing: border-box; ')
    .replace(/(?:width: 100%; height: 100%; box-sizing: border-box;\s*){2,}/g, "width: 100%; height: 100%; box-sizing: border-box; ");

  if (after !== before) {
    fs.writeFileSync(file, after, "utf8");
    changed += 1;
  }
}

console.log(`Polished ${changed} Mermaid SVG files.`);
