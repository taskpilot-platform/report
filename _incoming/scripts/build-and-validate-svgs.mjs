import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";

const root = path.resolve(import.meta.dirname, "..");
const diagramsDir = path.join(root, "asset", "assets", "diagrams");
const chapter2Dir = path.join(root, "asset", "chapter2");

console.log("Running refine_architecture_svgs.mjs...");
execSync("node scripts/refine_architecture_svgs.mjs", { stdio: "inherit" });

function validateDirectory(dir) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    if (file.endsWith(".svg")) {
      const p = path.join(dir, file);
      const content = fs.readFileSync(p, "utf8");
      if (content.includes("${")) {
        console.error(`ERROR: SVG file ${p} contains literal "\\${". It seems a template variable was not evaluated!`);
        process.exit(1);
      }
    }
  }
}

console.log("Validating SVGs...");
validateDirectory(diagramsDir);
validateDirectory(chapter2Dir);
console.log("Validation passed! All SVGs are fully evaluated.");

console.log("Exporting to PNG...");
execSync("node scripts/export_selected_svgs_to_png.mjs", { stdio: "inherit" });
console.log("Done!");
