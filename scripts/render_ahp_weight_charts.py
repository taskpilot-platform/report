from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "src" / "assets" / "diagrams"


MODES = {
    "balanced": {
        "title": "AHP weights - BALANCED",
        "color": "#2563eb",
        "values": [
            ("workload cost\nL(u)", 0.648),
            ("skill fit\nF(u,t)", 0.230),
            ("performance\nP(u)", 0.122),
        ],
    },
    "urgent": {
        "title": "AHP weights - URGENT",
        "color": "#dc2626",
        "values": [
            ("workload cost\nL(u)", 0.053),
            ("skill fit\nF(u,t)", 0.474),
            ("performance\nP(u)", 0.474),
        ],
    },
    "training": {
        "title": "AHP weights - TRAINING",
        "color": "#0f766e",
        "values": [
            ("workload cost\nL(u)", 0.731),
            ("skill fit\nF(u,t)", 0.188),
            ("performance\nP(u)", 0.081),
        ],
    },
}


def multiline_text(x, y, text, size=16, weight=600, fill="#1f2937"):
    lines = text.split("\n")
    start = y - (len(lines) - 1) * 10
    return "\n".join(
        f"<text x='{x}' y='{start + i * 22}' text-anchor='middle' "
        f"font-family='Arial, Helvetica, sans-serif' font-size='{size}' "
        f"font-weight='{weight}' fill='{fill}'>{line}</text>"
        for i, line in enumerate(lines)
    )


def render(mode, config):
    chart_top = 112
    chart_bottom = 350
    chart_height = chart_bottom - chart_top
    xs = [305, 505, 705]
    bar_w = 112
    parts = [
        "<svg xmlns='http://www.w3.org/2000/svg' width='1000' height='430' viewBox='0 0 1000 430'>",
        "<rect width='100%' height='100%' fill='#ffffff'/>",
        "<rect x='16' y='16' width='968' height='398' rx='10' fill='#f8fafc' stroke='#cbd5e1'/>",
        multiline_text(500, 56, config["title"], size=24, weight=700),
        "<line x1='190' y1='110' x2='190' y2='350' stroke='#64748b'/>",
        "<line x1='190' y1='350' x2='830' y2='350' stroke='#64748b'/>",
        "<text x='170' y='116' text-anchor='end' font-family='Arial, Helvetica, sans-serif' font-size='12' fill='#475569'>1.0</text>",
        "<text x='170' y='350' text-anchor='end' font-family='Arial, Helvetica, sans-serif' font-size='12' fill='#475569'>0.0</text>",
    ]
    for x, (label, value) in zip(xs, config["values"]):
        h = round(value * chart_height)
        y = chart_bottom - h
        parts.extend(
            [
                f"<rect x='{x - bar_w / 2}' y='{y}' width='{bar_w}' height='{h}' rx='7' fill='{config['color']}'/>",
                multiline_text(x, y - 16, f"{value:.3f}", size=16, weight=700),
                multiline_text(x, 378, label, size=14, weight=600),
            ]
        )
    parts.append("</svg>")
    (OUT / f"ch3_12_ahp_weights_{mode}.svg").write_text("\n".join(parts), encoding="utf8")


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    for mode, config in MODES.items():
        render(mode, config)
