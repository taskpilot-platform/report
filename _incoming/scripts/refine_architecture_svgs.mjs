import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const diagramsDir = path.join(root, "asset", "assets", "diagrams");
const chapter2Dir = path.join(root, "asset", "chapter2");
const selectedFiles = new Set(
  (process.env.REFINE_ONLY ?? "")
    .split(",")
    .map((name) => name.trim())
    .filter(Boolean),
);

function write(file, svg) {
  if (selectedFiles.size > 0 && !selectedFiles.has(path.basename(file))) return;
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, `${svg.trim()}\n`, "utf8");
}

function icon(rel, x, y, size = 34) {
  const name = path.basename(rel);
  const logoPath = [
    path.join(root, "..", "src", "assets", "taskpilot", "chapter2", name),
    path.join(root, "asset", "assets", "images", "logos", name),
  ].find((candidate) => fs.existsSync(candidate));
  if (!logoPath) throw new Error(`Missing logo: ${name}`);
  const data = fs.readFileSync(logoPath).toString("base64");
  const pad = Math.max(6, Math.round(size * 0.18));
  const box = size + pad * 2;
  return `<rect x="${x - pad}" y="${y - pad}" width="${box}" height="${box}" rx="${Math.round(size * 0.22)}" fill="#f8fafc" stroke="#dbe3ee" stroke-width="0.9"/>
<image href="data:image/svg+xml;base64,${data}" x="${x}" y="${y}" width="${size}" height="${size}" preserveAspectRatio="xMidYMid meet"/>`;
}

function browserGlyph(x, y, w = 42, h = 30) {
  return `<rect class="box" x="${x}" y="${y}" width="${w}" height="${h}" rx="5"/>
<circle cx="${x + 8}" cy="${y + 8}" r="2.4" fill="#ef4444"/>
<circle cx="${x + 16}" cy="${y + 8}" r="2.4" fill="#f59e0b"/>
<circle cx="${x + 24}" cy="${y + 8}" r="2.4" fill="#22c55e"/>
<line x1="${x + 4}" y1="${y + 14}" x2="${x + w - 4}" y2="${y + 14}" stroke="#30384d" stroke-width="1"/>`;
}

function roundPath(pts, r = 16) {
  let d = `M${pts[0][0]} ${pts[0][1]}`;
  for (let i = 1; i < pts.length - 1; i++) {
    const p0 = pts[i - 1], p1 = pts[i], p2 = pts[i + 1];
    const dx1 = p1[0] - p0[0], dy1 = p1[1] - p0[1];
    const len1 = Math.hypot(dx1, dy1);
    const ux1 = dx1 / len1, uy1 = dy1 / len1;
    const dx2 = p2[0] - p1[0], dy2 = p2[1] - p1[1];
    const len2 = Math.hypot(dx2, dy2);
    const ux2 = dx2 / len2, uy2 = dy2 / len2;
    const actualR = Math.min(r, len1 / 2, len2 / 2);
    const cx1 = p1[0] - ux1 * actualR, cy1 = p1[1] - uy1 * actualR;
    const cx2 = p1[0] + ux2 * actualR, cy2 = p1[1] + uy2 * actualR;
    d += ` L${cx1} ${cy1} Q${p1[0]} ${p1[1]} ${cx2} ${cy2}`;
  }
  const last = pts[pts.length - 1];
  d += ` L${last[0]} ${last[1]}`;
  return d;
}

const css = `
<style>
  text { font-family: Inter, Arial, sans-serif; fill: #172033; dominant-baseline: middle; }
  .canvas { fill: none; }
  .zone { fill: #cfd5e2; stroke: #30384d; stroke-width: 1.4; rx: 22; }
  .group { fill: #dfe4ee; stroke: #30384d; stroke-width: 1.2; rx: 18; }
  .box { fill: #f8fafc; stroke: #30384d; stroke-width: 1.1; rx: 16; }
  .muted { fill: #e6eaf2; stroke: #667085; stroke-dasharray: 5 4; rx: 16; }
  .label { font-size: 15px; font-weight: 700; }
  .small { font-size: 12px; font-weight: 600; }
  .tiny { font-size: 10px; font-weight: 600; }
  .line { fill: none; stroke: #30384d; stroke-width: 1.35; marker-end: url(#arrow); }
  .dash { fill: none; stroke: #697386; stroke-width: 1.25; stroke-dasharray: 5 4; marker-end: url(#arrow); }
</style>
<defs>
  <marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
    <path d="M 0 0 L 10 5 L 0 10 z" fill="#30384d"/>
  </marker>
</defs>`;

//write(path.join(chapter2Dir, "ch2_01_agile_scrum.svg"), `
//<svg xmlns="http://www.w3.org/2000/svg" width="1220" height="660" viewBox="0 0 1220 660">
//${css}
//<rect class="canvas" x="24" y="28" width="1172" height="604" rx="24"/>
//<text class="label" x="610" y="70" text-anchor="middle">Agile / Scrum delivery cycle</text>
//<rect class="box" x="76" y="266" width="152" height="96" rx="22"/><text class="small" x="152" y="304" text-anchor="middle">Product vision</text><text class="tiny" x="152" y="328" text-anchor="middle">goals and needs</text>
//<rect class="box" x="292" y="266" width="160" height="96" rx="22"/><text class="small" x="372" y="304" text-anchor="middle">Product backlog</text><text class="tiny" x="372" y="328" text-anchor="middle">prioritized work</text>
//<rect class="box" x="516" y="140" width="172" height="96" rx="22"/><text class="small" x="602" y="178" text-anchor="middle">Sprint planning</text><text class="tiny" x="602" y="202" text-anchor="middle">select sprint goal</text>
//<rect class="box" x="498" y="284" width="214" height="132" rx="26"/><text class="small" x="605" y="320" text-anchor="middle">Sprint execution</text><text class="tiny" x="605" y="346" text-anchor="middle">design, build, test</text><text class="tiny" x="605" y="368" text-anchor="middle">daily inspection</text>
//<rect class="box" x="778" y="140" width="158" height="96" rx="22"/><text class="small" x="857" y="178" text-anchor="middle">Sprint review</text><text class="tiny" x="857" y="202" text-anchor="middle">inspect increment</text>
//<rect class="box" x="778" y="424" width="158" height="96" rx="22"/><text class="small" x="857" y="462" text-anchor="middle">Retrospective</text><text class="tiny" x="857" y="486" text-anchor="middle">improve process</text>
//<rect class="box" x="994" y="266" width="150" height="96" rx="22"/><text class="small" x="1069" y="304" text-anchor="middle">Release-ready</text><text class="tiny" x="1069" y="328" text-anchor="middle">increment</text>
//<path class="line" d="M228 314 L292 314"/><path class="line" d="M452 314 C486 270 500 224 516 188"/><path class="line" d="M602 236 L602 284"/>
//<path class="line" d="M712 350 C758 308 778 244 778 188"/><path class="line" d="M936 188 C1030 188 1069 220 1069 266"/>
//<path class="line" d="M1069 362 C1040 442 984 472 936 472"/><path class="line" d="M778 472 C690 520 556 500 500 414"/><path class="dash" d="M778 472 C580 590 374 510 372 362"/>
//</svg>`);

//write(path.join(chapter2Dir, "ch2_02_scrum_sprint.svg"), `
//<svg xmlns="http://www.w3.org/2000/svg" width="1180" height="680" viewBox="0 0 1180 680">
//${css}
//<rect class="canvas" x="24" y="28" width="1132" height="624" rx="24"/>
//<text class="label" x="590" y="70" text-anchor="middle">Scrum sprint workflow</text>
//<rect class="box" x="74" y="278" width="160" height="96" rx="22"/><text class="small" x="154" y="316" text-anchor="middle">Product backlog</text><text class="tiny" x="154" y="340" text-anchor="middle">ordered ideas</text>
//<rect class="box" x="302" y="128" width="170" height="96" rx="22"/><text class="small" x="387" y="166" text-anchor="middle">Sprint planning</text><text class="tiny" x="387" y="190" text-anchor="middle">goal + scope</text>
//<rect class="box" x="302" y="430" width="170" height="96" rx="22"/><text class="small" x="387" y="468" text-anchor="middle">Sprint backlog</text><text class="tiny" x="387" y="492" text-anchor="middle">selected tasks</text>
//<rect class="box" x="548" y="196" width="250" height="238" rx="30"/><text class="small" x="673" y="232" text-anchor="middle">Sprint</text><text class="tiny" x="673" y="256" text-anchor="middle">one to four weeks</text>
//<rect class="box" x="590" y="288" width="166" height="72" rx="20"/><text class="small" x="673" y="332" text-anchor="middle">Daily scrum</text>
//<rect class="box" x="866" y="128" width="170" height="96" rx="22"/><text class="small" x="951" y="166" text-anchor="middle">Increment</text><text class="tiny" x="951" y="190" text-anchor="middle">potentially shippable</text>
//<rect class="box" x="866" y="430" width="170" height="96" rx="22"/><text class="small" x="951" y="468" text-anchor="middle">Review + retro</text><text class="tiny" x="951" y="492" text-anchor="middle">feedback loop</text>
//<path class="line" d="M234 326 C282 270 310 220 302 176"/><path class="line" d="M234 326 C282 382 310 430 302 478"/>
//<path class="line" d="M472 176 C510 192 528 212 548 236"/><path class="line" d="M472 478 C516 454 536 422 548 394"/>
//<path class="line" d="M798 238 C832 206 846 184 866 176"/><path class="line" d="M798 394 C832 426 846 468 866 478"/>
//<path class="dash" d="M951 430 C1094 350 1086 208 1036 176"/><path class="dash" d="M866 478 C646 608 304 590 154 374"/>
//</svg>`);

//write(path.join(chapter2Dir, "ch2_03_kanban.svg"), `
//<svg xmlns="http://www.w3.org/2000/svg" width="1220" height="680" viewBox="0 0 1220 680">
//${css}
//<rect class="canvas" x="24" y="28" width="1172" height="624" rx="24"/>
//<text class="label" x="610" y="70" text-anchor="middle">Kanban board with work-in-progress limits</text>
//<rect class="zone" x="72" y="116" width="1076" height="474" rx="28"/>
//<text class="small" x="204" y="156" text-anchor="middle">Backlog</text><text class="small" x="470" y="156" text-anchor="middle">In progress · WIP 3</text><text class="small" x="736" y="156" text-anchor="middle">Review</text><text class="small" x="1002" y="156" text-anchor="middle">Done</text>
//<line x1="338" y1="132" x2="338" y2="560" stroke="#30384d" stroke-width="1"/><line x1="604" y1="132" x2="604" y2="560" stroke="#30384d" stroke-width="1"/><line x1="870" y1="132" x2="870" y2="560" stroke="#30384d" stroke-width="1"/>
//<rect class="box" x="112" y="202" width="184" height="84" rx="20"/><text class="small" x="204" y="236" text-anchor="middle">Login page</text><text class="tiny" x="204" y="258" text-anchor="middle">ready to start</text>
//<rect class="box" x="112" y="320" width="184" height="84" rx="20"/><text class="small" x="204" y="354" text-anchor="middle">Project settings</text><text class="tiny" x="204" y="376" text-anchor="middle">needs refinement</text>
//<rect class="box" x="378" y="202" width="184" height="84" rx="20"/><text class="small" x="470" y="236" text-anchor="middle">Kanban UI</text><text class="tiny" x="470" y="258" text-anchor="middle">implementation</text>
//<rect class="box" x="378" y="320" width="184" height="84" rx="20"/><text class="small" x="470" y="354" text-anchor="middle">Notifications</text><text class="tiny" x="470" y="376" text-anchor="middle">SSE stream</text>
//<rect class="box" x="644" y="202" width="184" height="84" rx="20"/><text class="small" x="736" y="236" text-anchor="middle">AI chat flow</text><text class="tiny" x="736" y="258" text-anchor="middle">QA review</text>
//<rect class="box" x="910" y="202" width="184" height="84" rx="20"/><text class="small" x="1002" y="236" text-anchor="middle">Auth module</text><text class="tiny" x="1002" y="258" text-anchor="middle">completed</text>
//<rect class="box" x="910" y="320" width="184" height="84" rx="20"/><text class="small" x="1002" y="354" text-anchor="middle">CI pipeline</text><text class="tiny" x="1002" y="376" text-anchor="middle">completed</text>
//<path class="line" d="M296 244 L378 244"/><path class="line" d="M562 244 L644 244"/><path class="line" d="M828 244 L910 244"/>
//</svg>`);

write(path.join(diagramsDir, "ch3_01_asana_views.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1120" height="620" viewBox="0 0 1120 620">
${css}
<rect class="canvas" x="24" y="28" width="1072" height="564" rx="24"/>
<text class="label" x="560" y="70" text-anchor="middle">Asana project views</text>
<rect class="box" x="424" y="106" width="272" height="128" rx="24"/>
${icon("../images/logos/asana-logo.svg", 542, 128, 36)}
<text class="small" x="560" y="184" text-anchor="middle">Asana project</text>
<text class="tiny" x="560" y="208" text-anchor="middle">one workspace, multiple planning views</text>
<rect class="box" x="76" y="312" width="154" height="86" rx="22"/><text class="small" x="153" y="348" text-anchor="middle">List view</text><text class="tiny" x="153" y="370" text-anchor="middle">task fields</text>
<rect class="box" x="278" y="312" width="154" height="86" rx="22"/><text class="small" x="355" y="348" text-anchor="middle">Board view</text><text class="tiny" x="355" y="370" text-anchor="middle">status tracking</text>
<rect class="box" x="480" y="312" width="154" height="86" rx="22"/><text class="small" x="557" y="348" text-anchor="middle">Timeline</text><text class="tiny" x="557" y="370" text-anchor="middle">dependencies</text>
<rect class="box" x="682" y="312" width="154" height="86" rx="22"/><text class="small" x="759" y="348" text-anchor="middle">Calendar</text><text class="tiny" x="759" y="370" text-anchor="middle">due dates</text>
<rect class="box" x="884" y="312" width="154" height="86" rx="22"/><text class="small" x="961" y="348" text-anchor="middle">Workload</text><text class="tiny" x="961" y="370" text-anchor="middle">capacity</text>
<rect class="box" x="76" y="464" width="154" height="70" rx="20"/><text class="small" x="153" y="506" text-anchor="middle">Assignee</text>
<rect class="box" x="278" y="464" width="154" height="70" rx="20"/><text class="small" x="355" y="506" text-anchor="middle">Track status</text>
<rect class="box" x="480" y="464" width="154" height="70" rx="20"/><text class="small" x="557" y="506" text-anchor="middle">Plan work</text>
<path class="line" d="M560 234 C468 262 244 274 153 312"/><path class="line" d="M560 234 C488 272 410 288 355 312"/><path class="line" d="M560 234 L557 312"/><path class="line" d="M560 234 C632 272 704 288 759 312"/><path class="line" d="M560 234 C654 262 870 274 961 312"/>
<path class="line" d="M153 398 L153 464"/><path class="line" d="M355 398 L355 464"/><path class="line" d="M557 398 L557 464"/>
</svg>`);

//write(path.join(chapter2Dir, "ch2_07_modular_monolith.svg"), `
//<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="620" viewBox="0 0 1200 620">
//${css}
//<rect class="canvas" x="24" y="24" width="1152" height="572" rx="12"/>
//<text class="label" x="600" y="62" text-anchor="middle">Modular Monolith: One Deployment, Strong Internal Boundaries</text>
//<rect class="zone" x="148" y="92" width="904" height="418"/>
//<text class="small" x="600" y="122" text-anchor="middle">Single application process / single deployable artifact</text>
//<rect class="box" x="482" y="148" width="236" height="72"/>
//${icon("../assets/images/logos/springboot-logo.svg", 504, 166, 34)}
//<text class="small" x="622" y="178" text-anchor="middle">Application Shell</text>
//<text class="tiny" x="622" y="198" text-anchor="middle">Spring Boot entrypoint</text>
//<rect class="box" x="206" y="264" width="230" height="150"/>
//<text class="small" x="321" y="292" text-anchor="middle">Users Module</text>
//<text class="tiny" x="321" y="316" text-anchor="middle">Auth, profiles, skills</text>
//<rect class="box" x="486" y="264" width="230" height="150"/>
//<text class="small" x="601" y="292" text-anchor="middle">Projects Module</text>
//<text class="tiny" x="601" y="316" text-anchor="middle">Projects, sprints, tasks</text>
//<rect class="box" x="766" y="264" width="230" height="150"/>
//<text class="small" x="881" y="292" text-anchor="middle">AI Module</text>
//<text class="tiny" x="881" y="316" text-anchor="middle">Copilot, tools, routing</text>
//<rect class="box" x="402" y="452" width="396" height="70"/>
//<text class="small" x="600" y="480" text-anchor="middle">Internal Contracts / Ports</text>
//<text class="tiny" x="600" y="500" text-anchor="middle">DTOs and interfaces keep module dependencies explicit</text>
//<path class="line" d="M600 220 C600 238 600 246 600 264"/>
//<path class="line" d="M565 220 C420 232 321 242 321 264"/>
//<path class="line" d="M635 220 C780 232 881 242 881 264"/>
//<path class="line" d="M321 414 C378 438 463 448 506 452"/>
//<path class="line" d="M600 414 L600 452"/>
//<path class="line" d="M881 414 C824 438 738 448 694 452"/>
//<path class="dash" d="M486 338 C462 338 460 338 436 338"/>
//<path class="dash" d="M716 338 C742 338 740 338 766 338"/>
//</svg>`);

write(path.join(diagramsDir, "ch3_03_system_context.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<rect class="box" x="60" y="278" width="108" height="84"/><text class="small" x="114" y="306" text-anchor="middle">User</text>${browserGlyph(93, 320, 42, 30)}
<rect class="box" x="214" y="246" width="86" height="148"/><text class="tiny" x="257" y="274" text-anchor="middle">Browser</text>
<rect class="zone" x="358" y="76" width="820" height="490"/><text class="small" x="768" y="104" text-anchor="middle">TaskPilot System Boundary</text>
<rect class="box" x="408" y="142" width="176" height="116"/><text class="small" x="496" y="170" text-anchor="middle">React SPA</text>${icon("../images/logos/react-logo.svg", 479, 190, 38)}
<rect class="box" x="668" y="142" width="226" height="116"/><text class="small" x="781" y="170" text-anchor="middle">Spring Boot Backend</text>${icon("../images/logos/springboot-logo.svg", 764, 190, 38)}
<rect class="box" x="428" y="326" width="178" height="116"/><text class="small" x="517" y="354" text-anchor="middle">PostgreSQL</text>${icon("../images/logos/postgresql-logo.svg", 500, 374, 38)}
<rect class="box" x="654" y="326" width="178" height="116"/><text class="small" x="743" y="354" text-anchor="middle">Object Storage</text><text class="label" x="743" y="400" text-anchor="middle" fill="#0ea5e9">S3</text>
<rect class="box" x="882" y="326" width="218" height="116"/><text class="small" x="991" y="354" text-anchor="middle">External Services</text>${icon("../images/logos/onesignal-logo.svg", 940, 374, 34)}${icon("../images/logos/brevo-logo.svg", 1000, 374, 34)}${icon("../images/logos/gemini-star-logo.svg", 1048, 374, 34)}
<path class="line" d="M168 320 C185 320 196 320 214 320"/>
<path class="line" d="M300 320 C350 250 360 205 408 200"/>
<path class="line" d="M584 200 C618 200 632 200 668 200"/>
<path class="line" d="M781 258 C716 302 618 315 517 326"/>
<path class="line" d="M804 258 C789 290 766 308 743 326"/>
<path class="line" d="M844 258 C900 290 948 305 991 326"/>
<path class="dash" d="M668 220 C620 230 606 230 584 220"/>
</svg>`);

write(path.join(diagramsDir, "ch3_13_deployment_architecture.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<text class="label" x="640" y="62" text-anchor="middle">TaskPilot Deployment Architecture</text>
<rect class="box" x="58" y="260" width="110" height="88"/><text class="small" x="113" y="290" text-anchor="middle">User</text>${browserGlyph(92, 306, 42, 30)}
<rect class="box" x="236" y="122" width="176" height="126"/><text class="small" x="324" y="150" text-anchor="middle">Frontend Hosting</text>${icon("../images/logos/netlify-logo.svg", 280, 172, 34)}${icon("../images/logos/vercel-logo.svg", 338, 172, 34)}
<rect class="box" x="236" y="356" width="176" height="126"/><text class="small" x="324" y="384" text-anchor="middle">CI/CD</text>${icon("../images/logos/github-actions-logo.svg", 307, 408, 40)}
<rect class="zone" x="500" y="92" width="680" height="440"/><text class="small" x="840" y="120" text-anchor="middle">Managed Runtime and Services</text>
<rect class="box" x="542" y="176" width="206" height="126"/><text class="small" x="645" y="204" text-anchor="middle">Backend Container</text>${icon("../images/logos/docker-logo.svg", 586, 226, 34)}${icon("../images/logos/huggingface-logo.svg", 644, 226, 34)}${icon("../images/logos/springboot-logo.svg", 702, 226, 34)}
<rect class="box" x="814" y="160" width="146" height="100"/><text class="small" x="887" y="188" text-anchor="middle">PostgreSQL</text>${icon("../images/logos/postgresql-logo.svg", 870, 208, 34)}
<rect class="box" x="994" y="160" width="146" height="100"/><text class="small" x="1067" y="188" text-anchor="middle">Storage</text>${icon("../images/logos/supabase-logo.svg", 1050, 208, 34)}
<rect class="box" x="814" y="334" width="146" height="100"/><text class="small" x="887" y="362" text-anchor="middle">Email</text>${icon("../images/logos/brevo-logo.svg", 870, 382, 34)}
<rect class="box" x="994" y="334" width="146" height="100"/><text class="small" x="1067" y="362" text-anchor="middle">Push / AI</text>${icon("../images/logos/onesignal-logo.svg", 1030, 382, 32)}${icon("../images/logos/gemini-star-logo.svg", 1078, 382, 32)}
<path class="line" d="M168 304 C198 240 216 190 236 184"/>
<path class="line" d="M412 184 C455 194 500 216 542 234"/>
<path class="line" d="M412 418 C452 372 498 292 542 254"/>
<path class="line" d="M748 234 C780 220 790 210 814 210"/>
<path class="line" d="M748 242 C852 226 928 212 994 210"/>
<path class="line" d="M748 260 C806 312 824 350 887 334"/>
<path class="line" d="M748 272 C890 322 952 356 994 384"/>
</svg>`);

write(path.join(diagramsDir, "ch3_06_backend_modular_monolith.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1260" height="640" viewBox="0 0 1260 640">
${css}
<rect class="canvas" x="24" y="28" width="1212" height="584" rx="12"/>
<rect class="box" x="58" y="278" width="140" height="84"/><text class="small" x="128" y="308" text-anchor="middle">Frontend</text>${icon("../images/logos/react-logo.svg", 111, 326, 34)}
<rect class="zone" x="270" y="78" width="760" height="464"/><text class="small" x="650" y="106" text-anchor="middle">Spring Boot Modular Monolith</text>
<rect class="box" x="514" y="136" width="272" height="76"/><text class="small" x="650" y="164" text-anchor="middle">taskpilot-app</text><text class="tiny" x="650" y="186" text-anchor="middle">Composition root and runtime entrypoint</text>
<rect class="box" x="320" y="260" width="180" height="112"/><text class="small" x="410" y="290" text-anchor="middle">Users</text><text class="tiny" x="410" y="314" text-anchor="middle">auth, profile, skill</text>
<rect class="box" x="535" y="260" width="180" height="112"/><text class="small" x="625" y="290" text-anchor="middle">Projects</text><text class="tiny" x="625" y="314" text-anchor="middle">project, task, sprint</text>
<rect class="box" x="750" y="260" width="180" height="112"/><text class="small" x="840" y="290" text-anchor="middle">AI Copilot</text><text class="tiny" x="840" y="314" text-anchor="middle">chat, tools, routing</text>
<rect class="box" x="420" y="426" width="240" height="78"/><text class="small" x="540" y="456" text-anchor="middle">taskpilot-contracts</text><text class="tiny" x="540" y="478" text-anchor="middle">ports and DTOs</text>
<rect class="box" x="704" y="426" width="240" height="78"/><text class="small" x="824" y="456" text-anchor="middle">Infrastructure</text><text class="tiny" x="824" y="478" text-anchor="middle">security, storage, notification</text>
<rect class="box" x="1082" y="238" width="120" height="116"/><text class="small" x="1142" y="266" text-anchor="middle">Data</text>${icon("../images/logos/postgresql-logo.svg", 1105, 286, 28)}${icon("../images/logos/redis-logo.svg", 1148, 286, 28)}
<rect class="box" x="1082" y="394" width="120" height="116"/><text class="small" x="1142" y="422" text-anchor="middle">Providers</text>${icon("../images/logos/gemini-star-logo.svg", 1105, 442, 28)}${icon("../images/logos/groq-logo.svg", 1148, 442, 28)}
<path class="line" d="M198 320 C232 302 246 292 270 290"/>
<path class="line" d="M650 212 L650 260"/>
<path class="line" d="M600 212 C512 230 430 242 410 260"/>
<path class="line" d="M700 212 C778 230 830 242 840 260"/>
<path class="line" d="M410 372 C442 400 480 418 540 426"/>
<path class="line" d="M625 372 C606 396 580 414 540 426"/>
<path class="line" d="M840 372 C790 402 738 418 660 456"/>
<path class="line" d="M824 504 C910 470 1010 340 1082 300"/>
<path class="line" d="M840 372 C910 390 1000 420 1082 448"/>
</svg>`);

write(path.join(diagramsDir, "ch3_02_analysis_design_process.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="900" height="980" viewBox="0 0 900 980">
${css}
<rect class="canvas" x="28" y="28" width="844" height="924" rx="24"/>
<text class="label" x="450" y="70" text-anchor="middle">Analysis and design process</text>
<rect class="box" x="295" y="118" width="310" height="78" rx="18"/><text class="small" x="450" y="150" text-anchor="middle">Survey existing tools</text><text class="tiny" x="450" y="172" text-anchor="middle">Jira, Trello, Asana</text>
<rect class="box" x="295" y="242" width="310" height="78" rx="18"/><text class="small" x="450" y="274" text-anchor="middle">Define requirements</text><text class="tiny" x="450" y="296" text-anchor="middle">scope and core workflows</text>
<rect class="box" x="295" y="366" width="310" height="78" rx="18"/><text class="small" x="450" y="398" text-anchor="middle">Model use cases</text><text class="tiny" x="450" y="420" text-anchor="middle">actors and functional boundaries</text>
<rect class="box" x="295" y="490" width="310" height="78" rx="18"/><text class="small" x="450" y="522" text-anchor="middle">Design system architecture</text><text class="tiny" x="450" y="544" text-anchor="middle">frontend, backend, services</text>
<rect class="box" x="295" y="614" width="310" height="78" rx="18"/><text class="small" x="450" y="646" text-anchor="middle">Design data model</text><text class="tiny" x="450" y="668" text-anchor="middle">ERD and migration strategy</text>
<rect class="box" x="295" y="738" width="310" height="78" rx="18"/><text class="small" x="450" y="770" text-anchor="middle">Detail behavior diagrams</text><text class="tiny" x="450" y="792" text-anchor="middle">sequence and activity flows</text>
<rect class="box" x="295" y="862" width="310" height="58" rx="18"/><text class="small" x="450" y="896" text-anchor="middle">Design AI copilot and assignment</text>
<path class="line" d="M450 196 L450 242"/><path class="line" d="M450 320 L450 366"/><path class="line" d="M450 444 L450 490"/><path class="line" d="M450 568 L450 614"/><path class="line" d="M450 692 L450 738"/><path class="line" d="M450 816 L450 862"/>
</svg>`);

write(path.join(diagramsDir, "ch3_02_testing_deployment_process.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1180" height="650" viewBox="0 0 1180 650">
${css}
<rect class="canvas" x="24" y="28" width="1132" height="594" rx="24"/>
<text class="label" x="590" y="66" text-anchor="middle">Testing and deployment process</text>
<rect class="box" x="78" y="160" width="164" height="120" rx="20"/><text class="small" x="160" y="192" text-anchor="middle">Feature build</text><text class="tiny" x="160" y="214" text-anchor="middle">frontend + backend</text>
<rect class="box" x="310" y="94" width="164" height="120" rx="20"/><text class="small" x="392" y="126" text-anchor="middle">API testing</text>${icon("../images/logos/postman-logo.svg", 375, 146, 36)}
<rect class="box" x="310" y="250" width="164" height="120" rx="20"/><text class="small" x="392" y="282" text-anchor="middle">Data validation</text>${icon("../images/logos/supabase-logo.svg", 352, 302, 34)}${icon("../images/logos/postgresql-logo.svg", 404, 302, 34)}
<rect class="box" x="542" y="172" width="164" height="120" rx="20"/><text class="small" x="624" y="204" text-anchor="middle">CI workflow</text>${icon("../images/logos/github-actions-logo.svg", 604, 224, 40)}
<rect class="box" x="774" y="94" width="164" height="120" rx="20"/><text class="small" x="856" y="126" text-anchor="middle">Frontend deploy</text>${icon("../images/logos/netlify-logo.svg", 814, 146, 34)}${icon("../images/logos/vercel-logo.svg", 866, 146, 34)}
<rect class="box" x="774" y="250" width="164" height="120" rx="20"/><text class="small" x="856" y="282" text-anchor="middle">Backend deploy</text>${icon("../images/logos/huggingface-logo.svg", 816, 302, 34)}${icon("../images/logos/docker-logo.svg", 866, 302, 34)}
<rect class="box" x="990" y="172" width="120" height="120" rx="20"/><text class="small" x="1050" y="204" text-anchor="middle">Runtime</text>${icon("../images/logos/springboot-logo.svg", 1032, 226, 36)}
<path class="line" d="M242 204 C270 166 284 154 310 154"/><path class="line" d="M242 236 C270 280 284 310 310 310"/>
<path class="line" d="M474 154 C504 176 516 196 542 212"/><path class="line" d="M474 310 C506 282 520 260 542 244"/>
<path class="line" d="M706 212 C736 176 748 154 774 154"/><path class="line" d="M706 244 C738 278 750 310 774 310"/>
<path class="line" d="M938 154 C966 174 980 196 990 214"/><path class="line" d="M938 310 C966 288 980 264 990 246"/>
</svg>`);

write(path.join(diagramsDir, "ch3_03_frontend_spa_architecture.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1180" height="660" viewBox="0 0 1180 660">
${css}
<rect class="canvas" x="24" y="28" width="1132" height="604" rx="24"/>
<text class="label" x="590" y="66" text-anchor="middle">Frontend SPA architecture</text>
<rect class="zone" x="88" y="104" width="1004" height="458" rx="24"/><text class="small" x="590" y="134" text-anchor="middle">React + TypeScript + Vite client application</text>
<rect class="box" x="148" y="178" width="166" height="112" rx="20"/><text class="small" x="231" y="210" text-anchor="middle">Pages and screens</text>${icon("../images/logos/react-logo.svg", 214, 230, 36)}
<rect class="box" x="380" y="178" width="166" height="112" rx="20"/><text class="small" x="463" y="210" text-anchor="middle">Routing guard</text><text class="tiny" x="463" y="244" text-anchor="middle">protected routes</text>
<rect class="box" x="612" y="178" width="166" height="112" rx="20"/><text class="small" x="695" y="210" text-anchor="middle">State store</text>${icon("../images/logos/zustand-logo.svg", 678, 230, 36)}
<rect class="box" x="844" y="178" width="166" height="112" rx="20"/><text class="small" x="927" y="210" text-anchor="middle">UI system</text>${icon("../images/logos/tailwindcss-logo.svg", 858, 232, 28)}${icon("../images/logos/radixui-logo.svg", 904, 232, 28)}${icon("../images/logos/lucide-logo.svg", 950, 232, 28)}
<rect class="box" x="264" y="374" width="184" height="112" rx="20"/><text class="small" x="356" y="406" text-anchor="middle">API client</text>${icon("../images/logos/typescript-logo.svg", 338, 426, 36)}
<rect class="box" x="506" y="374" width="184" height="112" rx="20"/><text class="small" x="598" y="406" text-anchor="middle">SSE client</text><text class="tiny" x="598" y="436" text-anchor="middle">notification, comment</text><text class="tiny" x="598" y="454" text-anchor="middle">and AI stream</text>
<rect class="box" x="748" y="374" width="184" height="112" rx="20"/><text class="small" x="840" y="406" text-anchor="middle">Push integration</text>${icon("../images/logos/onesignal-logo.svg", 822, 426, 36)}
<rect class="box" x="480" y="560" width="220" height="46" rx="18"/><text class="small" x="590" y="588" text-anchor="middle">Built with Vite</text>${icon("../images/logos/vite-logo.svg", 664, 570, 26)}
<path class="line" d="M314 234 L380 234"/><path class="line" d="M546 234 L612 234"/><path class="line" d="M778 234 L844 234"/>
<path class="line" d="${roundPath([[231, 290], [231, 332], [356, 332], [356, 374]])}"/><path class="line" d="${roundPath([[695, 290], [695, 332], [598, 332], [598, 374]])}"/><path class="line" d="${roundPath([[927, 290], [927, 332], [840, 332], [840, 374]])}"/>
</svg>`);

write(path.join(diagramsDir, "ch3_03_interaction_overview.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1240" height="660" viewBox="0 0 1240 660">
${css}
<rect class="canvas" x="24" y="28" width="1192" height="604" rx="24"/>
<text class="label" x="620" y="66" text-anchor="middle">System interaction overview</text>
<rect class="box" x="70" y="260" width="150" height="118" rx="20"/><text class="small" x="145" y="292" text-anchor="middle">Frontend SPA</text>${icon("../images/logos/react-logo.svg", 126, 314, 38)}
<rect class="box" x="300" y="250" width="180" height="138" rx="20"/><text class="small" x="390" y="282" text-anchor="middle">Backend API</text>${icon("../images/logos/springboot-logo.svg", 370, 304, 38)}<text class="tiny" x="390" y="356" text-anchor="middle">REST + SSE</text>
<rect class="zone" x="560" y="98" width="600" height="438" rx="24"/><text class="small" x="860" y="128" text-anchor="middle">Data stores and external providers</text>
<rect class="box" x="610" y="174" width="142" height="106" rx="20"/><text class="small" x="681" y="202" text-anchor="middle">PostgreSQL</text>${icon("../images/logos/postgresql-logo.svg", 664, 222, 36)}
<rect class="box" x="802" y="174" width="142" height="106" rx="20"/><text class="small" x="873" y="202" text-anchor="middle">Storage</text>${icon("../images/logos/supabase-logo.svg", 856, 222, 36)}
<rect class="box" x="994" y="174" width="112" height="106" rx="20"/><text class="small" x="1050" y="202" text-anchor="middle">Email</text>${icon("../images/logos/brevo-logo.svg", 1032, 222, 36)}
<rect class="box" x="610" y="356" width="142" height="106" rx="20"/><text class="small" x="681" y="384" text-anchor="middle">Push</text>${icon("../images/logos/onesignal-logo.svg", 664, 404, 36)}
<rect class="box" x="802" y="356" width="304" height="106" rx="20"/><text class="small" x="954" y="384" text-anchor="middle">AI providers</text>${icon("../images/logos/gemini-star-logo.svg", 872, 404, 34)}${icon("../images/logos/openai-logo.svg", 936, 404, 34)}${icon("../images/logos/groq-logo.svg", 1000, 404, 34)}
<path class="line" d="${roundPath([[220, 314], [260, 314], [260, 300], [300, 300]])}"/>
<path class="dash" d="${roundPath([[300, 346], [260, 346], [260, 352], [220, 352]])}"/>
<path class="line" d="${roundPath([[480, 288], [592, 288], [592, 227], [610, 227]])}"/>
<path class="line" d="${roundPath([[480, 306], [536, 306], [536, 150], [784, 150], [784, 227], [802, 227]])}"/>
<path class="line" d="${roundPath([[480, 324], [518, 324], [518, 136], [970, 136], [970, 227], [994, 227]])}"/>
<path class="line" d="${roundPath([[480, 346], [592, 346], [592, 409], [610, 409]])}"/>
<path class="line" d="${roundPath([[480, 364], [536, 364], [536, 494], [784, 494], [784, 409], [802, 409]])}"/>
</svg>`);

write(path.join(diagramsDir, "ch3_03_system_context.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="690" viewBox="0 0 1280 690">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="634" rx="24"/>
<text class="label" x="640" y="66" text-anchor="middle">TaskPilot system context</text>
<rect class="box" x="58" y="292" width="118" height="96" rx="20"/><text class="small" x="117" y="324" text-anchor="middle">User</text>${browserGlyph(96, 340, 42, 30)}
<rect class="box" x="232" y="266" width="112" height="148" rx="20"/><text class="small" x="288" y="302" text-anchor="middle">Browser</text>${browserGlyph(267, 326, 42, 30)}
<rect class="zone" x="416" y="100" width="774" height="470" rx="24"/><text class="small" x="803" y="130" text-anchor="middle">TaskPilot boundary</text>
<rect class="box" x="470" y="178" width="172" height="116" rx="20"/><text class="small" x="556" y="210" text-anchor="middle">React SPA</text>${icon("../images/logos/react-logo.svg", 538, 230, 38)}
<rect class="box" x="712" y="178" width="210" height="116" rx="20"/><text class="small" x="817" y="210" text-anchor="middle">Spring Boot backend</text>${icon("../images/logos/springboot-logo.svg", 798, 230, 38)}
<rect class="box" x="474" y="370" width="142" height="104" rx="20"/><text class="small" x="545" y="398" text-anchor="middle">Database</text>${icon("../images/logos/postgresql-logo.svg", 528, 418, 34)}
<rect class="box" x="664" y="370" width="142" height="104" rx="20"/><text class="small" x="735" y="398" text-anchor="middle">Storage</text>${icon("../images/logos/supabase-logo.svg", 718, 418, 34)}
<rect class="box" x="854" y="370" width="250" height="104" rx="20"/><text class="small" x="979" y="398" text-anchor="middle">External services</text>${icon("../images/logos/brevo-logo.svg", 904, 420, 30)}${icon("../images/logos/onesignal-logo.svg", 950, 420, 30)}${icon("../images/logos/gemini-star-logo.svg", 996, 420, 30)}${icon("../images/logos/openai-logo.svg", 1042, 420, 30)}
<rect class="box" x="976" y="178" width="132" height="116" rx="20"/><text class="small" x="1042" y="210" text-anchor="middle">CI/CD</text>${icon("../images/logos/github-actions-logo.svg", 1022, 232, 38)}
<path class="line" d="M176 340 C198 340 214 340 232 340"/><path class="line" d="M344 340 C386 270 420 238 470 236"/>
<path class="line" d="M642 236 L712 236"/><path class="line" d="M817 294 C742 332 642 352 545 370"/><path class="line" d="M842 294 C806 334 770 352 735 370"/><path class="line" d="M872 294 C914 330 946 350 979 370"/>
<path class="dash" d="M976 236 C946 236 940 236 922 236"/>
</svg>`);

write(path.join(diagramsDir, "ch3_06_backend_modular_monolith.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1260" height="640" viewBox="0 0 1260 640">
${css}
<rect class="canvas" x="24" y="28" width="1212" height="584" rx="24"/>
<text class="label" x="630" y="68" text-anchor="middle">Backend modular monolith</text>
<rect class="box" x="58" y="278" width="140" height="84" rx="20"/><text class="small" x="128" y="310" text-anchor="middle">Frontend</text>${icon("../images/logos/react-logo.svg", 111, 328, 34)}
<rect class="zone" x="270" y="100" width="760" height="430" rx="24"/><text class="small" x="650" y="130" text-anchor="middle">Spring Boot runtime</text>
<rect class="box" x="514" y="164" width="272" height="76" rx="20"/><text class="small" x="650" y="194" text-anchor="middle">taskpilot-app</text><text class="tiny" x="650" y="216" text-anchor="middle">composition root</text>
<rect class="box" x="320" y="288" width="180" height="92" rx="20"/><text class="small" x="410" y="330" text-anchor="middle">Users module</text><text class="tiny" x="410" y="352" text-anchor="middle">auth, profile, skill</text>
<rect class="box" x="535" y="288" width="180" height="92" rx="20"/><text class="small" x="625" y="330" text-anchor="middle">Projects module</text><text class="tiny" x="625" y="352" text-anchor="middle">project, task, sprint</text>
<rect class="box" x="750" y="288" width="180" height="92" rx="20"/><text class="small" x="840" y="330" text-anchor="middle">AI module</text><text class="tiny" x="840" y="352" text-anchor="middle">chat, tools, routing</text>
<rect class="box" x="420" y="438" width="240" height="70" rx="20"/><text class="small" x="540" y="470" text-anchor="middle">taskpilot-contracts</text><text class="tiny" x="540" y="492" text-anchor="middle">ports and DTOs</text>
<rect class="box" x="704" y="438" width="240" height="70" rx="20"/><text class="small" x="824" y="470" text-anchor="middle">Infrastructure</text><text class="tiny" x="824" y="492" text-anchor="middle">security, storage, notification</text>
<rect class="box" x="1082" y="238" width="120" height="116" rx="20"/><text class="small" x="1142" y="266" text-anchor="middle">Data</text>${icon("../images/logos/postgresql-logo.svg", 1105, 286, 28)}${icon("../images/logos/redis-logo.svg", 1148, 286, 28)}
<rect class="box" x="1082" y="394" width="120" height="116" rx="20"/><text class="small" x="1142" y="422" text-anchor="middle">Providers</text>${icon("../images/logos/gemini-star-logo.svg", 1105, 442, 28)}${icon("../images/logos/groq-logo.svg", 1148, 442, 28)}
<path class="line" d="M198 320 C232 302 246 292 270 290"/><path class="line" d="M650 240 L650 288"/><path class="line" d="M600 240 C512 252 430 264 410 288"/><path class="line" d="M700 240 C778 252 830 264 840 288"/>
<path class="line" d="M410 380 C442 410 480 430 540 438"/><path class="line" d="M625 380 C606 405 580 425 540 438"/><path class="line" d="M840 380 C790 410 738 428 660 470"/>
<path class="line" d="M824 508 C910 470 1010 340 1082 300"/><path class="line" d="M840 380 C910 400 1000 426 1082 448"/>
</svg>`);

write(path.join(diagramsDir, "ch3_08_flyway_change_management.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1160" height="620" viewBox="0 0 1160 620">
${css}
<rect class="canvas" x="24" y="28" width="1112" height="564" rx="24"/>
<text class="label" x="580" y="66" text-anchor="middle">Database change management with Flyway</text>
<rect class="box" x="70" y="238" width="150" height="112" rx="20"/><text class="small" x="145" y="270" text-anchor="middle">Migration script</text><text class="tiny" x="145" y="302" text-anchor="middle">V__*.sql</text>
<rect class="box" x="284" y="238" width="150" height="112" rx="20"/><text class="small" x="359" y="270" text-anchor="middle">Repository</text>${icon("../images/logos/github-logo.svg", 342, 292, 34)}
<rect class="box" x="498" y="238" width="150" height="112" rx="20"/><text class="small" x="573" y="270" text-anchor="middle">Spring Boot startup</text>${icon("../images/logos/springboot-logo.svg", 556, 292, 34)}
<rect class="box" x="712" y="166" width="150" height="112" rx="20"/><text class="small" x="787" y="198" text-anchor="middle">Flyway validate</text>${icon("../images/logos/flyway-logo.svg", 770, 220, 34)}
<rect class="box" x="712" y="332" width="150" height="112" rx="20"/><text class="small" x="787" y="364" text-anchor="middle">Apply migration</text>${icon("../images/logos/flyway-logo.svg", 770, 386, 34)}
<rect class="box" x="926" y="166" width="150" height="112" rx="20"/><text class="small" x="1001" y="198" text-anchor="middle">Schema history</text><text class="tiny" x="1001" y="232" text-anchor="middle">flyway_schema_history</text>
<rect class="box" x="926" y="332" width="150" height="112" rx="20"/><text class="small" x="1001" y="364" text-anchor="middle">PostgreSQL schema</text>${icon("../images/logos/postgresql-logo.svg", 984, 386, 34)}
<path class="line" d="M220 294 L284 294"/><path class="line" d="M434 294 L498 294"/><path class="line" d="M648 278 C676 246 688 224 712 222"/><path class="line" d="M648 310 C676 350 688 386 712 388"/>
<path class="line" d="M862 222 L926 222"/><path class="line" d="M862 388 L926 388"/><path class="dash" d="M1001 278 L1001 332"/>
</svg>`);

write(path.join(chapter2Dir, "ch2_19_sse.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1160" height="600" viewBox="0 0 1160 600">
${css}
<rect class="canvas" x="24" y="28" width="1112" height="544" rx="24"/>
<text class="label" x="580" y="66" text-anchor="middle">Server-Sent Events (SSE) stream</text>
<rect class="box" x="140" y="160" width="180" height="280" rx="20"/>
${browserGlyph(209, 180, 42, 30)}
<text class="small" x="230" y="240" text-anchor="middle">Frontend Client</text>
${icon("../images/logos/react-logo.svg", 212, 260, 36)}
<text class="tiny" x="230" y="320" text-anchor="middle">EventSource API</text>

<rect class="box" x="840" y="160" width="180" height="280" rx="20"/>
<text class="small" x="930" y="240" text-anchor="middle">Backend Server</text>
${icon("../images/logos/springboot-logo.svg", 912, 260, 36)}
<text class="tiny" x="930" y="320" text-anchor="middle">SseEmitter</text>

<!-- HTTP GET -->
<path class="line" d="M320 200 L840 200"/>
<text class="small" x="580" y="184" text-anchor="middle">1. HTTP GET (Accept: text/event-stream)</text>

<!-- HTTP 200 -->
<path class="line" d="M840 240 L320 240"/>
<text class="small" x="580" y="224" text-anchor="middle">2. HTTP 200 OK (Content-Type: text/event-stream)</text>

<!-- Data Stream -->
<rect class="muted" x="380" y="280" width="400" height="130" rx="16"/>
<path class="dash" d="M840 310 L320 310"/>
<text class="tiny" x="580" y="300" text-anchor="middle">data: {"event":"AI_STREAM", "chunk":"Here is the task..."}</text>

<path class="dash" d="M840 350 L320 350"/>
<text class="tiny" x="580" y="340" text-anchor="middle">data: {"event":"KANBAN_UPDATE", "taskId":42}</text>

<path class="dash" d="M840 390 L320 390"/>
<text class="tiny" x="580" y="380" text-anchor="middle">...</text>
<text class="small" x="580" y="440" text-anchor="middle">3. Persistent uni-directional data stream over single TCP connection</text>
</svg>`);

write(path.join(chapter2Dir, "ch2_22_cicd_deployment.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1240" height="660" viewBox="0 0 1240 660">
${css}
<rect class="canvas" x="24" y="28" width="1192" height="604" rx="24"/>
<text class="label" x="620" y="66" text-anchor="middle">CI/CD Pipeline and Deployment</text>

<!-- Developer -->
<rect class="box" x="80" y="260" width="120" height="120" rx="20"/>
<text class="small" x="140" y="300" text-anchor="middle">Developer</text>
<text class="tiny" x="140" y="330" text-anchor="middle">git push</text>

<!-- GitHub -->
<rect class="box" x="280" y="260" width="140" height="120" rx="20"/>
<text class="small" x="350" y="340" text-anchor="middle">GitHub Repo</text>
${icon("../images/logos/github-logo.svg", 330, 280, 40)}

<!-- GitHub Actions -->
<rect class="zone" x="480" y="160" width="280" height="320" rx="24"/>
<text class="small" x="620" y="190" text-anchor="middle">GitHub Actions CI/CD</text>
${icon("../images/logos/github-actions-logo.svg", 600, 210, 40)}

<rect class="box" x="530" y="270" width="180" height="60" rx="16"/>
<text class="small" x="620" y="300" text-anchor="middle">1. Build &amp; Test</text>

<rect class="box" x="530" y="350" width="180" height="60" rx="16"/>
<text class="small" x="620" y="380" text-anchor="middle">2. Docker Package</text>

<!-- Frontend Deploy -->
<rect class="box" x="860" y="180" width="240" height="120" rx="20"/>
<text class="small" x="980" y="220" text-anchor="middle">Frontend Hosting</text>
${icon("../images/logos/vercel-logo.svg", 940, 240, 36)}
${icon("../images/logos/netlify-logo.svg", 990, 240, 36)}

<!-- Backend Deploy -->
<rect class="box" x="860" y="340" width="240" height="140" rx="20"/>
<text class="small" x="980" y="380" text-anchor="middle">Backend Container</text>
${icon("../images/logos/huggingface-logo.svg", 940, 400, 36)}
${icon("../images/logos/docker-logo.svg", 990, 400, 36)}

<path class="line" d="M200 320 L280 320"/>
<path class="line" d="M420 320 L480 320"/>
<path class="line" d="M620 330 L620 350"/>
<path class="line" d="${roundPath([[760, 300], [800, 300], [800, 240], [860, 240]])}"/>
<path class="line" d="${roundPath([[760, 380], [800, 380], [800, 410], [860, 410]])}"/>

<text class="tiny" x="810" y="230" text-anchor="middle">Deploy SPA</text>
<text class="tiny" x="810" y="400" text-anchor="middle">Deploy Image</text>

</svg>`);

write(path.join(diagramsDir, "ch3_11_ai_copilot_architecture.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<text class="label" x="640" y="62" text-anchor="middle">AI Copilot controlled architecture</text>
<rect class="box" x="58" y="200" width="180" height="150" rx="20"/><text class="small" x="148" y="230" text-anchor="middle">Frontend</text><text class="tiny" x="148" y="255" text-anchor="middle">React SPA UI</text>
${icon("../images/logos/react-logo.svg", 75, 280, 34)}${icon("../images/logos/typescript-logo.svg", 125, 280, 34)}${icon("../images/logos/tailwindcss-logo.svg", 175, 280, 34)}
<rect class="box" x="350" y="160" width="220" height="200" rx="20"/><text class="small" x="460" y="190" text-anchor="middle">Backend AI module</text><text class="tiny" x="460" y="215" text-anchor="middle">Spring Boot + LangChain4j</text>
${icon("../images/logos/springboot-logo.svg", 410, 250, 38)}${icon("../images/logos/langchain4j-logo.svg", 480, 250, 38)}
<rect class="box" x="350" y="420" width="220" height="130" rx="20"/><text class="small" x="460" y="450" text-anchor="middle">Memory &amp; State</text>
${icon("../images/logos/postgresql-logo.svg", 410, 485, 34)}${icon("../images/logos/redis-logo.svg", 470, 485, 34)}
<rect class="box" x="720" y="160" width="300" height="140" rx="20"/><text class="small" x="870" y="190" text-anchor="middle">AI Providers</text>
${icon("../images/logos/gemini-star-logo.svg", 750, 230, 34)}${icon("../images/logos/openai-logo.svg", 810, 230, 34)}${icon("../images/logos/groq-logo.svg", 870, 230, 34)}${icon("../images/logos/github-logo.svg", 930, 230, 34)}
<rect class="box" x="720" y="380" width="300" height="140" rx="20"/><text class="small" x="870" y="410" text-anchor="middle">Domain Tools</text>
${icon("../images/logos/springboot-logo.svg", 810, 450, 34)}${icon("../images/logos/postgresql-logo.svg", 870, 450, 34)}
<path class="line" d="M238 275 L350 275"/>
<path class="line" d="M570 230 L720 230"/>
<path class="line" d="M460 360 L460 420"/>
<path class="line" d="${roundPath([[570, 310], [630, 310], [650, 420], [720, 420]])}"/>
<path class="line" d="${roundPath([[720, 480], [650, 480], [620, 340], [570, 340]])}"/>
</svg>`);

write(path.join(diagramsDir, "ch3_11_smart_routing.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<text class="label" x="640" y="62" text-anchor="middle">Smart routing and provider selection</text>
<rect class="box" x="58" y="240" width="180" height="140" rx="20"/><text class="small" x="148" y="270" text-anchor="middle">User Request</text>
${icon("../images/logos/react-logo.svg", 131, 310, 34)}
<rect class="box" x="320" y="140" width="180" height="140" rx="20"/><text class="small" x="410" y="170" text-anchor="middle">Gatekeeper</text><text class="tiny" x="410" y="195" text-anchor="middle">Groq (Intent Classify)</text>
${icon("../images/logos/groq-logo.svg", 393, 220, 34)}
<rect class="box" x="320" y="360" width="180" height="140" rx="20"/><text class="small" x="410" y="390" text-anchor="middle">Routing Rules</text><text class="tiny" x="410" y="415" text-anchor="middle">Spring Boot Rules</text>
${icon("../images/logos/springboot-logo.svg", 393, 440, 34)}
<rect class="box" x="600" y="100" width="180" height="120" rx="20"/><text class="small" x="690" y="130" text-anchor="middle">Light route</text>
${icon("../images/logos/gemini-star-logo.svg", 673, 160, 34)}
<rect class="box" x="600" y="260" width="180" height="120" rx="20"/><text class="small" x="690" y="290" text-anchor="middle">Tool-aware route</text>
${icon("../images/logos/langchain4j-logo.svg", 673, 320, 34)}
<rect class="box" x="600" y="420" width="180" height="120" rx="20"/><text class="small" x="690" y="450" text-anchor="middle">Reasoning route</text>
${icon("../images/logos/openai-logo.svg", 650, 480, 30)}${icon("../images/logos/github-logo.svg", 700, 480, 30)}
<rect class="box" x="900" y="240" width="180" height="140" rx="20"/><text class="small" x="990" y="270" text-anchor="middle">Response Stream</text>
${icon("../images/logos/postgresql-logo.svg", 940, 310, 34)}${icon("../images/logos/redis-logo.svg", 1000, 310, 34)}
<path class="line" d="${roundPath([[238, 310], [270, 310], [290, 210], [320, 210]])}"/>
<path class="line" d="${roundPath([[238, 310], [270, 310], [290, 430], [320, 430]])}"/>
<path class="line" d="${roundPath([[500, 210], [540, 210], [560, 160], [600, 160]])}"/>
<path class="line" d="${roundPath([[500, 430], [560, 430], [560, 320], [600, 320]])}"/>
<path class="line" d="${roundPath([[500, 430], [540, 430], [560, 480], [600, 480]])}"/>
<path class="line" d="${roundPath([[780, 160], [830, 160], [860, 310], [900, 310]])}"/>
<path class="line" d="M780 320 L900 320"/>
<path class="line" d="${roundPath([[780, 480], [830, 480], [860, 330], [900, 330]])}"/>
</svg>`);

write(path.join(diagramsDir, "ch3_11_auto_fallback.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<text class="label" x="640" y="62" text-anchor="middle">Auto fallback across AI providers</text>
<rect class="box" x="58" y="240" width="180" height="140" rx="20"/><text class="small" x="148" y="270" text-anchor="middle">Initial Call</text><text class="tiny" x="148" y="295" text-anchor="middle">Gemini Primary</text>
${icon("../images/logos/gemini-star-logo.svg", 131, 320, 34)}
<rect class="box" x="320" y="140" width="180" height="140" rx="20"/><text class="small" x="410" y="170" text-anchor="middle">Retry Path</text><text class="tiny" x="410" y="195" text-anchor="middle">Gemini Alternate</text>
${icon("../images/logos/gemini-star-logo.svg", 393, 220, 34)}
<rect class="box" x="320" y="360" width="180" height="140" rx="20"/><text class="small" x="410" y="390" text-anchor="middle">External Fallback</text><text class="tiny" x="410" y="415" text-anchor="middle">OpenAI / GitHub</text>
${icon("../images/logos/openai-logo.svg", 370, 440, 30)}${icon("../images/logos/github-logo.svg", 420, 440, 30)}
<rect class="box" x="600" y="140" width="180" height="140" rx="20"/><text class="small" x="690" y="170" text-anchor="middle">Fast Fallback</text><text class="tiny" x="690" y="195" text-anchor="middle">Groq (Llama)</text>
${icon("../images/logos/groq-logo.svg", 673, 220, 34)}
<rect class="box" x="600" y="360" width="180" height="140" rx="20"/><text class="small" x="690" y="390" text-anchor="middle">Request State</text><text class="tiny" x="690" y="415" text-anchor="middle">PostgreSQL log</text>
${icon("../images/logos/postgresql-logo.svg", 673, 440, 34)}
<rect class="box" x="880" y="240" width="180" height="140" rx="20"/><text class="small" x="970" y="270" text-anchor="middle">Frontend Stream</text>
${icon("../images/logos/react-logo.svg", 920, 310, 34)}${icon("../images/logos/redis-logo.svg", 980, 310, 34)}
<path class="line" d="${roundPath([[238, 310], [270, 310], [290, 210], [320, 210]])}"/>
<path class="line" d="${roundPath([[238, 310], [270, 310], [290, 430], [320, 430]])}"/>
<path class="line" d="M500 210 L600 210"/>
<path class="line" d="M500 430 L600 430"/>
<path class="line" d="${roundPath([[780, 210], [820, 210], [850, 310], [880, 310]])}"/>
<path class="line" d="${roundPath([[780, 430], [820, 430], [850, 310], [880, 310]])}"/>
</svg>`);

write(path.join(diagramsDir, "ch3_11_tool_registry.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<text class="label" x="640" y="62" text-anchor="middle">Tool Calling Registry boundary</text>
<rect class="box" x="58" y="250" width="180" height="150" rx="20"/><text class="small" x="148" y="280" text-anchor="middle">AI Request</text><text class="tiny" x="148" y="305" text-anchor="middle">Gemini / LangChain4j</text>
${icon("../images/logos/gemini-star-logo.svg", 100, 335, 30)}${icon("../images/logos/langchain4j-logo.svg", 160, 335, 30)}
<rect class="box" x="320" y="230" width="220" height="190" rx="20"/><text class="small" x="430" y="260" text-anchor="middle">Tool Registry</text><text class="tiny" x="430" y="285" text-anchor="middle">Spring Boot + LC4j</text>
${icon("../images/logos/springboot-logo.svg", 380, 320, 38)}${icon("../images/logos/langchain4j-logo.svg", 440, 320, 38)}
<rect class="box" x="650" y="80" width="180" height="100" rx="20"/><text class="small" x="740" y="108" text-anchor="middle">Project tools</text>
${icon("../images/logos/postgresql-logo.svg", 723, 128, 34)}
<rect class="box" x="650" y="190" width="180" height="100" rx="20"/><text class="small" x="740" y="218" text-anchor="middle">Task tools</text>
${icon("../images/logos/springboot-logo.svg", 723, 238, 34)}
<rect class="box" x="650" y="300" width="180" height="100" rx="20"/><text class="small" x="740" y="328" text-anchor="middle">Read tools</text>
${icon("../images/logos/redis-logo.svg", 723, 348, 34)}
<rect class="box" x="650" y="410" width="180" height="100" rx="20"/><text class="small" x="740" y="438" text-anchor="middle">Write tools</text>
${icon("../images/logos/springboot-logo.svg", 723, 458, 34)}
<rect class="box" x="650" y="520" width="180" height="100" rx="20"/><text class="small" x="740" y="548" text-anchor="middle">Audit tools</text>
${icon("../images/logos/postgresql-logo.svg", 723, 568, 34)}
<path class="line" d="M238 325 L320 325"/>
<path class="line" d="${roundPath([[540, 325], [600, 325], [610, 125], [650, 125]])}"/>
<path class="line" d="${roundPath([[540, 325], [600, 325], [610, 235], [650, 235]])}"/>
<path class="line" d="M540 325 L650 325"/>
<path class="line" d="${roundPath([[540, 325], [600, 325], [610, 455], [650, 455]])}"/>
<path class="line" d="${roundPath([[540, 325], [600, 325], [610, 565], [650, 565]])}"/>
</svg>`);

write(path.join(diagramsDir, "ch3_12_assignment_recommendation_process.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<text class="label" x="640" y="62" text-anchor="middle">Assignment recommendation pipeline</text>
<rect class="box" x="58" y="240" width="180" height="140" rx="20"/><text class="small" x="148" y="270" text-anchor="middle">Task Input</text>
${icon("../images/logos/react-logo.svg", 131, 310, 34)}
<rect class="box" x="320" y="140" width="180" height="140" rx="20"/><text class="small" x="410" y="170" text-anchor="middle">Project context</text><text class="tiny" x="410" y="195" text-anchor="middle">Members &amp; Skills</text>
${icon("../images/logos/postgresql-logo.svg", 370, 220, 30)}${icon("../images/logos/springboot-logo.svg", 420, 220, 30)}
<rect class="box" x="320" y="360" width="180" height="140" rx="20"/><text class="small" x="410" y="390" text-anchor="middle">AI Copilot</text><text class="tiny" x="410" y="415" text-anchor="middle">Gemini Analysis</text>
${icon("../images/logos/gemini-star-logo.svg", 370, 440, 30)}${icon("../images/logos/langchain4j-logo.svg", 420, 440, 30)}
<rect class="box" x="600" y="240" width="180" height="140" rx="20"/><text class="small" x="690" y="270" text-anchor="middle">Heuristic scoring</text><text class="tiny" x="690" y="295" text-anchor="middle">Spring Boot</text>
${icon("../images/logos/springboot-logo.svg", 673, 320, 34)}
<rect class="box" x="880" y="140" width="180" height="140" rx="20"/><text class="small" x="970" y="170" text-anchor="middle">Candidate ranking</text>
${icon("../images/logos/postgresql-logo.svg", 953, 210, 34)}
<rect class="box" x="880" y="360" width="180" height="140" rx="20"/><text class="small" x="970" y="390" text-anchor="middle">User Decision</text><text class="tiny" x="970" y="415" text-anchor="middle">PM confirmation</text>
${icon("../images/logos/react-logo.svg", 953, 440, 34)}
<path class="line" d="${roundPath([[238, 310], [270, 310], [290, 210], [320, 210]])}"/>
<path class="line" d="${roundPath([[238, 310], [270, 310], [290, 430], [320, 430]])}"/>
<path class="line" d="${roundPath([[500, 210], [540, 210], [560, 300], [600, 300]])}"/>
<path class="line" d="${roundPath([[500, 430], [540, 430], [560, 320], [600, 320]])}"/>
<path class="line" d="${roundPath([[780, 310], [820, 310], [840, 210], [880, 210]])}"/>
<path class="line" d="M970 280 L970 360"/>
</svg>`);

write(path.join(diagramsDir, "ch3_13_external_connection_flow.svg"), `
<svg xmlns="http://www.w3.org/2000/svg" width="1280" height="650" viewBox="0 0 1280 650">
${css}
<rect class="canvas" x="24" y="28" width="1232" height="594" rx="12"/>
<text class="label" x="640" y="62" text-anchor="middle">External connection and service integration flow</text>
<rect class="box" x="58" y="200" width="180" height="150" rx="20"/><text class="small" x="148" y="230" text-anchor="middle">Frontend SPA</text>
${icon("../images/logos/react-logo.svg", 75, 275, 34)}${icon("../images/logos/typescript-logo.svg", 125, 275, 34)}${icon("../images/logos/tailwindcss-logo.svg", 175, 275, 34)}
<rect class="box" x="350" y="240" width="180" height="150" rx="20"/><text class="small" x="440" y="270" text-anchor="middle">Backend runtime</text><text class="tiny" x="440" y="295" text-anchor="middle">Spring Boot API</text>
${icon("../images/logos/springboot-logo.svg", 423, 320, 34)}
<rect class="box" x="58" y="430" width="180" height="130" rx="20"/><text class="small" x="148" y="460" text-anchor="middle">Browser push</text><text class="tiny" x="148" y="485" text-anchor="middle">OS notifications</text>
${browserGlyph(127, 510, 42, 30)}
<rect class="box" x="650" y="70" width="180" height="100" rx="20"/><text class="small" x="740" y="98" text-anchor="middle">PostgreSQL Database</text>
${icon("../images/logos/postgresql-logo.svg", 723, 118, 34)}
<rect class="box" x="650" y="180" width="180" height="100" rx="20"/><text class="small" x="740" y="208" text-anchor="middle">Supabase Storage</text>
${icon("../images/logos/supabase-logo.svg", 723, 228, 34)}
<rect class="box" x="650" y="290" width="180" height="100" rx="20"/><text class="small" x="740" y="318" text-anchor="middle">Brevo SMTP</text>
${icon("../images/logos/brevo-logo.svg", 723, 338, 34)}
<rect class="box" x="650" y="400" width="180" height="100" rx="20"/><text class="small" x="740" y="428" text-anchor="middle">OneSignal API</text>
${icon("../images/logos/onesignal-logo.svg", 723, 448, 34)}
<rect class="box" x="650" y="510" width="180" height="100" rx="20"/><text class="small" x="740" y="538" text-anchor="middle">AI Providers</text>
${icon("../images/logos/gemini-star-logo.svg", 679, 558, 34)}${icon("../images/logos/openai-logo.svg", 723, 558, 34)}${icon("../images/logos/groq-logo.svg", 767, 558, 34)}
<path class="line" d="M238 250 L350 250"/>
<path class="line" d="M350 320 L238 320"/>
<path class="line" d="${roundPath([[530, 315], [580, 315], [610, 115], [650, 115]])}"/>
<path class="line" d="${roundPath([[530, 315], [580, 315], [610, 225], [650, 225]])}"/>
<path class="line" d="M530 315 L650 325"/>
<path class="line" d="${roundPath([[530, 315], [580, 315], [610, 445], [650, 445]])}"/>
<path class="line" d="${roundPath([[530, 315], [580, 315], [610, 555], [650, 555]])}"/>
<path class="line" d="${roundPath([[650, 445], [500, 445], [350, 480], [238, 480]])}"/>
<text class="tiny" x="294" y="235" text-anchor="middle">REST</text>
<text class="tiny" x="294" y="305" text-anchor="middle">SSE</text>
</svg>`);

console.log("Refined architecture SVGs with local icons.");

