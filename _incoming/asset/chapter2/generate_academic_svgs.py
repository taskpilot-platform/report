import os

def write_svg(filename, content):
    with open(filename, "w", encoding="utf-8") as f:
        f.write(content)

# Shared styles for academic look (blue/grey palette, crisp lines, clean font)
style = """
    <style>
      .bg { fill: #ffffff; }
      .box { fill: #f8fafc; stroke: #334155; stroke-width: 1.5; rx: 4; }
      .box-highlight { fill: #e0f2fe; stroke: #0284c7; stroke-width: 1.5; rx: 4; }
      .box-alt { fill: #f1f5f9; stroke: #475569; stroke-width: 1.5; rx: 4; stroke-dasharray: 4 4; }
      .title { font-family: 'Times New Roman', serif; font-size: 16px; font-weight: bold; fill: #0f172a; text-anchor: middle; }
      .text { font-family: 'Arial', sans-serif; font-size: 14px; fill: #1e293b; text-anchor: middle; }
      .text-small { font-family: 'Arial', sans-serif; font-size: 12px; fill: #475569; text-anchor: middle; }
      .text-left { font-family: 'Arial', sans-serif; font-size: 14px; fill: #1e293b; text-anchor: start; }
      .line { stroke: #334155; stroke-width: 1.5; fill: none; }
      .arrow { stroke: #334155; stroke-width: 1.5; fill: none; marker-end: url(#arrowhead); }
      .arrow-dashed { stroke: #475569; stroke-width: 1.5; fill: none; stroke-dasharray: 4 4; marker-end: url(#arrowhead); }
    </style>
    <defs>
      <marker id="arrowhead" markerWidth="8" markerHeight="6" refX="7" refY="3" orient="auto">
        <polygon points="0 0, 8 3, 0 6" fill="#334155" />
      </marker>
    </defs>
"""

def generate_modular_monolith():
    svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 400" width="100%" height="100%">
{style}
    <rect class="bg" width="100%" height="100%" />
    <!-- Monolith Application Boundary -->
    <rect class="box" x="50" y="50" width="600" height="220" />
    <text class="title" x="350" y="75">Modular Monolithic Application (Single Deployment Unit)</text>

    <!-- Presentation Layer -->
    <rect class="box-highlight" x="80" y="100" width="540" height="40" />
    <text class="text" x="350" y="125">API Gateway / Presentation Layer</text>

    <!-- Modules -->
    <rect class="box-alt" x="80" y="160" width="160" height="90" />
    <text class="text" x="160" y="190">Module A</text>
    <text class="text-small" x="160" y="210">(e.g., User Auth)</text>

    <rect class="box-alt" x="270" y="160" width="160" height="90" />
    <text class="text" x="350" y="190">Module B</text>
    <text class="text-small" x="350" y="210">(e.g., Project Mgmt)</text>

    <rect class="box-alt" x="460" y="160" width="160" height="90" />
    <text class="text" x="540" y="190">Module C</text>
    <text class="text-small" x="540" y="210">(e.g., Reporting)</text>

    <!-- Communication arrows -->
    <line class="arrow-dashed" x1="240" y1="205" x2="270" y2="205" />
    <text class="text-small" x="255" y="200">API</text>
    <line class="arrow-dashed" x1="430" y1="205" x2="460" y2="205" />
    <text class="text-small" x="445" y="200">API</text>

    <!-- Database -->
    <rect class="box" x="50" y="310" width="600" height="60" />
    <text class="title" x="350" y="335">Relational Database</text>
    <text class="text-small" x="350" y="355">Logically separated schemas per module</text>

    <line class="arrow" x1="160" y1="250" x2="160" y2="310" />
    <line class="arrow" x1="350" y1="250" x2="350" y2="310" />
    <line class="arrow" x1="540" y1="250" x2="540" y2="310" />
</svg>"""
    write_svg("ch2_07_modular_monolith.svg", svg)

def generate_agile_scrum():
    svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 350" width="100%" height="100%">
{style}
    <rect class="bg" width="100%" height="100%" />
    
    <!-- Product Backlog -->
    <rect class="box" x="30" y="120" width="120" height="150" />
    <text class="title" x="90" y="145">Product</text>
    <text class="title" x="90" y="165">Backlog</text>
    <line class="line" x1="40" y1="180" x2="110" y2="180" />
    <line class="line" x1="40" y1="200" x2="110" y2="200" />
    <line class="line" x1="40" y1="220" x2="110" y2="220" />
    <line class="line" x1="40" y1="240" x2="110" y2="240" />

    <line class="arrow" x1="150" y1="195" x2="190" y2="195" />
    <text class="text-small" x="170" y="185">Planning</text>

    <!-- Sprint Backlog -->
    <rect class="box-highlight" x="190" y="120" width="120" height="150" />
    <text class="title" x="250" y="145">Sprint</text>
    <text class="title" x="250" y="165">Backlog</text>
    <line class="line" x1="200" y1="180" x2="270" y2="180" />
    <line class="line" x1="200" y1="200" x2="270" y2="200" />

    <line class="arrow" x1="310" y1="195" x2="350" y2="195" />

    <!-- Sprint Circle -->
    <circle class="box" cx="440" cy="195" r="80" />
    <path class="arrow" d="M 440 115 A 80 80 0 0 1 520 195" />
    <path class="arrow" d="M 520 195 A 80 80 0 0 1 440 275" />
    <path class="arrow" d="M 440 275 A 80 80 0 0 1 360 195" />
    <text class="title" x="440" y="190">Sprint</text>
    <text class="text-small" x="440" y="210">(1-4 Weeks)</text>

    <!-- Daily Scrum -->
    <circle class="box-highlight" cx="440" cy="80" r="30" />
    <text class="text-small" x="440" y="75">Daily</text>
    <text class="text-small" x="440" y="90">Scrum</text>
    <line class="arrow-dashed" x1="440" y1="110" x2="440" y2="115" />

    <line class="arrow" x1="520" y1="195" x2="580" y2="195" />

    <!-- Working Increment -->
    <rect class="box" x="580" y="145" width="100" height="100" />
    <text class="title" x="630" y="185">Working</text>
    <text class="title" x="630" y="205">Increment</text>

    <!-- Review & Retrospective -->
    <line class="arrow-dashed" x1="630" y1="145" x2="630" y2="80" />
    <line class="arrow-dashed" x1="630" y1="80" x2="470" y2="80" />
    <text class="text-small" x="550" y="70">Sprint Review / Retrospective</text>
</svg>"""
    write_svg("ch2_01_agile_scrum.svg", svg)

def generate_cicd():
    svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 200" width="100%" height="100%">
{style}
    <rect class="bg" width="100%" height="100%" />
    
    <rect class="box-highlight" x="30" y="60" width="100" height="80" />
    <text class="title" x="80" y="100">Code</text>
    <text class="text-small" x="80" y="120">(Commit)</text>
    <line class="arrow" x1="130" y1="100" x2="170" y2="100" />

    <rect class="box" x="170" y="60" width="100" height="80" />
    <text class="title" x="220" y="100">Build</text>
    <text class="text-small" x="220" y="120">(Compile)</text>
    <line class="arrow" x1="270" y1="100" x2="310" y2="100" />

    <rect class="box" x="310" y="60" width="100" height="80" />
    <text class="title" x="360" y="100">Test</text>
    <text class="text-small" x="360" y="120">(Automated)</text>
    <line class="arrow" x1="410" y1="100" x2="450" y2="100" />

    <rect class="box-highlight" x="450" y="60" width="100" height="80" />
    <text class="title" x="500" y="100">Release</text>
    <text class="text-small" x="500" y="120">(Artifact)</text>
    <line class="arrow" x1="550" y1="100" x2="590" y2="100" />

    <rect class="box" x="590" y="60" width="100" height="80" />
    <text class="title" x="640" y="100">Deploy</text>
    <text class="text-small" x="640" y="120">(Production)</text>

    <!-- CI/CD groupings -->
    <path class="line" d="M 30 150 L 30 160 L 410 160 L 410 150" />
    <text class="title" x="220" y="180">Continuous Integration (CI)</text>

    <path class="line" d="M 450 150 L 450 160 L 690 160 L 690 150" />
    <text class="title" x="570" y="180">Continuous Deployment (CD)</text>
</svg>"""
    write_svg("ch2_22_cicd_deployment.svg", svg)

def generate_kanban():
    svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 700 400" width="100%" height="100%">
{style}
    <rect class="bg" width="100%" height="100%" />
    
    <rect class="box" x="30" y="30" width="640" height="340" />
    <text class="title" x="350" y="60">Kanban Board</text>
    <line class="line" x1="30" y1="80" x2="670" y2="80" />

    <!-- Columns -->
    <line class="line" x1="243" y1="80" x2="243" y2="370" />
    <line class="line" x1="456" y1="80" x2="456" y2="370" />

    <!-- Headers -->
    <text class="title" x="136" y="110">To Do</text>
    <text class="title" x="350" y="110">In Progress</text>
    <text class="text-small" x="350" y="130">(WIP Limit: 3)</text>
    <text class="title" x="563" y="110">Done</text>

    <!-- Cards -->
    <rect class="box-highlight" x="50" y="150" width="170" height="60" />
    <text class="text" x="135" y="185">Task 4</text>
    
    <rect class="box-highlight" x="50" y="230" width="170" height="60" />
    <text class="text" x="135" y="265">Task 5</text>

    <rect class="box-alt" x="263" y="150" width="170" height="60" />
    <text class="text" x="348" y="185">Task 2</text>

    <rect class="box-alt" x="263" y="230" width="170" height="60" />
    <text class="text" x="348" y="265">Task 3</text>

    <rect class="box" x="476" y="150" width="170" height="60" />
    <text class="text" x="561" y="185">Task 1</text>
</svg>"""
    write_svg("ch2_03_kanban.svg", svg)

if __name__ == "__main__":
    generate_modular_monolith()
    generate_agile_scrum()
    generate_cicd()
    generate_kanban()
    print("Generated all academic SVGs successfully.")
