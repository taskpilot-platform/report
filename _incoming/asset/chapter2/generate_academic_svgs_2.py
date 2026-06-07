import os

def write_svg(filename, content):
    with open(filename, "w", encoding="utf-8") as f:
        f.write(content)

style = """
    <style>
      .bg { fill: #ffffff; }
      .box { fill: #f8fafc; stroke: #334155; stroke-width: 1.5; rx: 4; }
      .box-highlight { fill: #e0f2fe; stroke: #0284c7; stroke-width: 1.5; rx: 4; }
      .box-alt { fill: #f1f5f9; stroke: #475569; stroke-width: 1.5; rx: 4; stroke-dasharray: 4 4; }
      .title { font-family: 'Times New Roman', serif; font-size: 16px; font-weight: bold; fill: #0f172a; text-anchor: middle; }
      .text { font-family: 'Arial', sans-serif; font-size: 14px; fill: #1e293b; text-anchor: middle; }
      .text-small { font-family: 'Arial', sans-serif; font-size: 12px; fill: #475569; text-anchor: middle; }
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

def generate_agile():
    svg = f"""<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 250" width="100%" height="100%">
{style}
    <rect class="bg" width="100%" height="100%" />
    
    <text class="title" x="300" y="40">Agile Iterative Development Process</text>
    
    <!-- Iteration 1 -->
    <rect class="box" x="50" y="80" width="120" height="100" />
    <text class="text" x="110" y="125">Iteration 1</text>
    <text class="text-small" x="110" y="145">(Plan, Build, Test)</text>
    <line class="arrow" x1="170" y1="130" x2="230" y2="130" />

    <!-- Iteration 2 -->
    <rect class="box-highlight" x="240" y="80" width="120" height="100" />
    <text class="text" x="300" y="125">Iteration 2</text>
    <text class="text-small" x="300" y="145">(Plan, Build, Test)</text>
    <line class="arrow" x1="360" y1="130" x2="420" y2="130" />

    <!-- Iteration 3 -->
    <rect class="box" x="430" y="80" width="120" height="100" />
    <text class="text" x="490" y="125">Iteration n</text>
    <text class="text-small" x="490" y="145">(Plan, Build, Test)</text>
    
    <!-- Feedback loop -->
    <path class="arrow-dashed" d="M 490 200 L 490 220 L 110 220 L 110 200" />
    <text class="text-small" x="300" y="240">Continuous Customer Feedback &amp; Adaptation</text>
</svg>"""
    write_svg("ch2_01_agile_scrum.svg", svg)

def generate_scrum_sprint():
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
    write_svg("ch2_02_scrum_sprint.svg", svg)

if __name__ == "__main__":
    generate_agile()
    generate_scrum_sprint()
    print("Regenerated agile/scrum successfully.")
