from pathlib import Path
from math import atan2, cos, sin, pi
import tempfile

import cairosvg
from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "src" / "assets" / "diagrams"
LOGOS = ROOT / "src" / "assets" / "taskpilot" / "chapter2"


def font(size, bold=False):
    names = [
        ("C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf"),
        ("C:/Windows/Fonts/timesbd.ttf" if bold else "C:/Windows/Fonts/times.ttf"),
    ]
    for name in names:
        if Path(name).exists():
            return ImageFont.truetype(name, size)
    return ImageFont.load_default()


F_TITLE = font(38, True)
F_H = font(28, True)
F = font(24)
F_SMALL = font(18)
F_TINY = font(15)


def svg_to_png(path, size):
    path = Path(path)
    with tempfile.NamedTemporaryFile(suffix=".png", delete=False) as tmp:
        tmp_path = Path(tmp.name)
    cairosvg.svg2png(url=str(path), write_to=str(tmp_path), output_width=size, output_height=size)
    img = Image.open(tmp_path).convert("RGBA")
    tmp_path.unlink(missing_ok=True)
    return img


def logo(name, size=64):
    path = LOGOS / name
    if not path.exists():
        return None
    if path.suffix.lower() == ".svg":
        return svg_to_png(path, size)
    return Image.open(path).convert("RGBA").resize((size, size), Image.LANCZOS)


def canvas(title, w=2200, h=1150):
    img = Image.new("RGBA", (w, h), (255, 255, 255, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle((40, 40, w - 40, h - 40), radius=34, fill=(248, 250, 252, 255), outline=(205, 213, 223, 255), width=3)
    d.text((w // 2, 95), title, font=F_TITLE, fill=(15, 23, 42, 255), anchor="mm")
    return img, d


def text_lines(draw, text, font_obj, width):
    words = text.split()
    lines, cur = [], ""
    for word in words:
        nxt = word if not cur else f"{cur} {word}"
        if draw.textlength(nxt, font=font_obj) <= width:
            cur = nxt
        else:
            if cur:
                lines.append(cur)
            cur = word
    if cur:
        lines.append(cur)
    return lines


def box(draw, xy, title, subtitle=None, logos=None, fill=(255, 255, 255, 255), accent=(37, 99, 235, 255)):
    x1, y1, x2, y2 = xy
    compact = (y2 - y1) < 220
    draw.rounded_rectangle(xy, radius=28, fill=fill, outline=(100, 116, 139, 255), width=3)
    draw.rounded_rectangle((x1, y1, x1 + 16, y2), radius=8, fill=accent)
    draw.text((x1 + 44, y1 + 44), title, font=F_H, fill=(15, 23, 42, 255))
    if subtitle:
        y = y1 + 86
        text_width = x2 - x1 - (300 if compact and logos else 88)
        for line in text_lines(draw, subtitle, F_SMALL, text_width):
            draw.text((x1 + 44, y), line, font=F_SMALL, fill=(51, 65, 85, 255))
            y += 26
    if logos:
        if compact:
            x = x2 - 44 - 82 * len(logos)
            y = y1 + ((y2 - y1) - 58) // 2
        else:
            x = x1 + 44
            y = y2 - 92
        for item in logos:
            img = item if isinstance(item, Image.Image) else logo(item, 58)
            if img:
                draw.rounded_rectangle((x - 8, y - 8, x + 74, y + 74), radius=16, fill=(248, 250, 252, 255), outline=(226, 232, 240, 255), width=2)
                base.alpha_composite(img, (x + (58 - img.width) // 2, y + (58 - img.height) // 2))
                x += 82 if compact else 96


def arrow(draw, start, end, color=(71, 85, 105, 255), width=5):
    x1, y1 = start
    x2, y2 = end
    draw.line((x1, y1, x2, y2), fill=color, width=width)
    ang = atan2(y2 - y1, x2 - x1)
    size = 20
    pts = [
        (x2, y2),
        (x2 - size * cos(ang - pi / 6), y2 - size * sin(ang - pi / 6)),
        (x2 - size * cos(ang + pi / 6), y2 - size * sin(ang + pi / 6)),
    ]
    draw.polygon(pts, fill=color)


def poly_arrow(draw, points, color=(71, 85, 105, 255), width=5):
    if len(points) < 2:
        return
    if len(points) > 2:
        draw.line(points[:-1], fill=color, width=width, joint="curve")
    arrow(draw, points[-2], points[-1], color=color, width=width)


def label(draw, xy, text, color=(51, 65, 85, 255)):
    x, y = xy
    pad = 14
    bbox = draw.textbbox((0, 0), text, font=F_TINY)
    w = bbox[2] - bbox[0] + pad * 2
    h = bbox[3] - bbox[1] + pad
    draw.rounded_rectangle((x - w // 2, y - h // 2, x + w // 2, y + h // 2), radius=14, fill=(255, 255, 255, 245), outline=(203, 213, 225, 255), width=2)
    draw.text((x, y), text, font=F_TINY, fill=color, anchor="mm")


def save(img, name):
    img.save(OUT / name, "PNG", optimize=True)


def render_architecture():
    global base
    base, d = canvas("AI Copilot controlled architecture")
    boxes = {
        "ui": (120, 285, 520, 560),
        "api": (730, 240, 1160, 610),
        "data": (730, 740, 1160, 975),
        "providers": (1390, 240, 2080, 560),
        "tools": (1390, 715, 2080, 990),
    }
    box(d, boxes["ui"], "Frontend", "React UI receives chat input and streams response state.", ["react-logo.svg", "typescript-logo.svg", "tailwindcss-logo.svg"], accent=(14, 165, 233, 255))
    box(d, boxes["api"], "Backend AI module", "Spring Boot coordinates context, routing, tools, safety and logs.", ["springboot-logo.svg", "langchain4j-logo.svg"], accent=(34, 197, 94, 255))
    box(d, boxes["data"], "Memory and state", "Chat sessions, messages, requests, AI logs and short-lived context.", ["postgresql-logo.svg", "redis-logo.svg"], accent=(99, 102, 241, 255))
    box(d, boxes["providers"], "AI providers", "Models generate responses or structured tool calls only.", ["gemini-star-logo.svg", "groq-logo.svg", "github-logo.svg", "openai-logo.svg"], accent=(168, 85, 247, 255))
    box(d, boxes["tools"], "Domain tools", "Project, task, sprint, member and notification services enforce rules.", ["spring-data-logo.svg", "postgresql-logo.svg"], accent=(245, 158, 11, 255))
    arrow(d, (520, 425), (730, 425))
    arrow(d, (1160, 365), (1390, 365))
    arrow(d, (1160, 500), (1390, 825))
    arrow(d, (945, 610), (945, 740))
    arrow(d, (1390, 900), (1160, 500))
    label(d, (625, 390), "REST/SSE")
    label(d, (1275, 330), "prompt + tools")
    label(d, (1265, 690), "validated calls")
    label(d, (1040, 680), "audit + memory")
    save(base, "ch3_11_ai_copilot_architecture.png")


def render_smart_routing():
    global base
    base, d = canvas("Smart routing and provider selection", h=1050)
    nodes = [
        ((100, 335, 420, 585), "User request", "Chat text, project scope and session state.", ["react-logo.svg"], (14, 165, 233, 255)),
        ((610, 215, 980, 500), "Gatekeeper", "Light intent classification and route hint.", ["groq-logo.svg"], (239, 68, 68, 255)),
        ((610, 585, 980, 890), "Routing rules", "Tool need, context size, fallback state and configuration.", ["springboot-logo.svg"], (34, 197, 94, 255)),
        ((1140, 150, 1510, 385), "Light route", "Short answer or simple lookup.", ["gemini-star-logo.svg"], (168, 85, 247, 255)),
        ((1140, 415, 1510, 650), "Tool-aware route", "Expose selected tool specs through LangChain4j.", ["langchain4j-logo.svg", "spring-data-logo.svg"], (245, 158, 11, 255)),
        ((1140, 680, 1510, 915), "Reasoning route", "Large context or assignment-support analysis.", ["github-logo.svg", "openai-logo.svg"], (99, 102, 241, 255)),
        ((1700, 380, 2070, 650), "Response stream", "Persist request state, logs and stream tokens to UI.", ["redis-logo.svg", "postgresql-logo.svg"], (20, 184, 166, 255)),
    ]
    for xy, title, sub, logos, accent in nodes:
        box(d, xy, title, sub, logos, accent=accent)
    arrow(d, (420, 460), (610, 357))
    arrow(d, (420, 460), (610, 737))
    arrow(d, (980, 357), (1140, 265))
    arrow(d, (980, 737), (1140, 532))
    arrow(d, (980, 737), (1140, 798))
    arrow(d, (1510, 265), (1700, 455))
    arrow(d, (1510, 532), (1700, 515))
    arrow(d, (1510, 798), (1700, 585))
    label(d, (520, 378), "classify")
    label(d, (520, 638), "rules")
    label(d, (1600, 430), "fallback if needed")
    save(base, "ch3_11_smart_routing.png")


def render_auto_fallback():
    global base
    base, d = canvas("Auto fallback across AI providers", h=1000)
    nodes = [
        ((90, 350, 390, 610), "Initial call", "Primary configured provider.", ["gemini-star-logo.svg"], (168, 85, 247, 255)),
        ((555, 230, 880, 490), "Retry path", "Retry compatible model or endpoint.", ["gemini-star-logo.svg"], (99, 102, 241, 255)),
        ((555, 610, 880, 870), "External fallback", "Route to OpenAI-compatible provider.", ["github-logo.svg", "openai-logo.svg"], (15, 23, 42, 255)),
        ((1060, 230, 1400, 490), "Fast fallback", "Use Groq for suitable lightweight requests.", ["groq-logo.svg"], (239, 68, 68, 255)),
        ((1060, 610, 1400, 870), "Request state", "Update ai_chat_requests and error metadata.", ["postgresql-logo.svg"], (34, 197, 94, 255)),
        ((1590, 405, 2070, 695), "Frontend stream", "Return response chunks or a clear failure state.", ["react-logo.svg", "redis-logo.svg"], (14, 165, 233, 255)),
    ]
    for xy, title, sub, logos, accent in nodes:
        box(d, xy, title, sub, logos, accent=accent)
    arrow(d, (390, 480), (555, 360))
    arrow(d, (390, 480), (555, 740))
    arrow(d, (880, 360), (1060, 360))
    arrow(d, (880, 740), (1060, 740))
    arrow(d, (1400, 360), (1590, 500))
    arrow(d, (1400, 740), (1590, 610))
    label(d, (475, 395), "timeout/error")
    label(d, (475, 625), "provider down")
    label(d, (1500, 445), "success")
    label(d, (1500, 665), "status")
    save(base, "ch3_11_auto_fallback.png")


def render_tool_registry():
    global base
    base, d = canvas("Tool Calling Registry boundary", h=1220)
    box(d, (95, 470, 460, 750), "AI request", "Model proposes a structured tool call.", ["gemini-star-logo.svg", "langchain4j-logo.svg"], accent=(168, 85, 247, 255))
    box(d, (640, 390, 1040, 840), "Registry", "Whitelisted tool specs with names, parameters and output schema.", ["springboot-logo.svg", "langchain4j-logo.svg"], accent=(34, 197, 94, 255))
    groups = [
        ((1260, 145, 2080, 325), "Project tools", "Projects, members and project roles.", ["postgresql-logo.svg"], (14, 165, 233, 255)),
        ((1260, 340, 2080, 520), "Task tools", "Tasks, sprint, backlog and Kanban state.", ["spring-data-logo.svg"], (245, 158, 11, 255)),
        ((1260, 535, 2080, 715), "Read tools", "Context, workload, comments and activity query.", ["redis-logo.svg"], (99, 102, 241, 255)),
        ((1260, 730, 2080, 910), "Write tools", "Pending confirmation before any data-changing action.", ["springboot-logo.svg"], (239, 68, 68, 255)),
        ((1260, 925, 2080, 1105), "Audit tools", "AI logs, request state and user feedback.", ["postgresql-logo.svg"], (20, 184, 166, 255)),
    ]
    for xy, title, sub, logos, accent in groups:
        box(d, xy, title, sub, logos, accent=accent)
    arrow(d, (460, 610), (640, 610))
    for target in [(1260, 235), (1260, 430), (1260, 625), (1260, 820), (1260, 1015)]:
        arrow(d, (1040, 615), target)
    label(d, (570, 570), "validated tool call")
    label(d, (1155, 575), "selected specs")
    save(base, "ch3_11_tool_registry.png")


def render_assignment():
    global base
    base, d = canvas("Assignment recommendation pipeline", h=1100)
    nodes = [
        ((90, 370, 420, 655), "Task input", "Title, description, priority, sprint and project scope.", ["react-logo.svg"], (14, 165, 233, 255)),
        ((600, 210, 960, 470), "Project context", "Members, skills, workload and recent activity.", ["postgresql-logo.svg", "spring-data-logo.svg"], (34, 197, 94, 255)),
        ((600, 660, 960, 920), "AI Copilot", "Natural-language request and explanation support.", ["gemini-star-logo.svg", "langchain4j-logo.svg"], (168, 85, 247, 255)),
        ((1150, 370, 1530, 655), "Heuristic scoring", "Skill match, workload balance, history and availability.", ["springboot-logo.svg"], (245, 158, 11, 255)),
        ((1720, 240, 2080, 500), "Candidate ranking", "Sorted assignee recommendations with scores.", ["postgresql-logo.svg"], (99, 102, 241, 255)),
        ((1720, 620, 2080, 880), "User decision", "Project manager accepts, adjusts or rejects.", ["react-logo.svg"], (20, 184, 166, 255)),
    ]
    for xy, title, sub, logos, accent in nodes:
        box(d, xy, title, sub, logos, accent=accent)
    arrow(d, (420, 510), (600, 340))
    arrow(d, (420, 510), (600, 790))
    arrow(d, (960, 340), (1150, 465))
    arrow(d, (960, 790), (1150, 560))
    arrow(d, (1530, 510), (1720, 370))
    arrow(d, (1900, 500), (1900, 620))
    label(d, (510, 395), "data")
    label(d, (510, 685), "request")
    label(d, (1060, 445), "features")
    label(d, (1060, 635), "intent")
    label(d, (1625, 425), "rank")
    save(base, "ch3_12_assignment_recommendation_process.png")


def render_external_connection():
    global base
    base, d = canvas("External connection and service integration flow", h=1150)
    nodes = [
        ((100, 320, 500, 580), "Frontend SPA", "React client application. Initiates REST requests and subscribes to SSE stream.", ["react-logo.svg", "typescript-logo.svg", "tailwindcss-logo.svg"], (14, 165, 233, 255)),
        ((700, 420, 1120, 720), "Backend runtime", "Spring Boot core process. Validates constraints, handles persistence and coordinates external integrations.", ["springboot-logo.svg"], (34, 197, 94, 255)),
        ((100, 760, 500, 980), "Browser push", "User browser or mobile device receives real-time OS-level notification alerts.", None, (100, 116, 139, 255)),
        ((1300, 150, 2080, 310), "PostgreSQL Database", "Primary database storing users, projects, tasks, sprints and system states.", ["postgresql-logo.svg"], (99, 102, 241, 255)),
        ((1300, 340, 2080, 500), "Supabase Storage", "Object storage (S3 API) for user avatars, task attachments and media assets.", ["supabase-logo.svg"], (14, 165, 233, 255)),
        ((1300, 530, 2080, 690), "Brevo SMTP", "Transactional email provider for password resets and system notifications.", ["brevo-logo.svg"], (245, 158, 11, 255)),
        ((1300, 720, 2080, 880), "OneSignal API", "Web push notifications service coordinating client subscription deliveries.", ["onesignal-logo.svg"], (239, 68, 68, 255)),
        ((1300, 910, 2080, 1070), "AI providers", "Gemini, OpenAI, Groq models generating response content and tool calls.", ["gemini-star-logo.svg", "openai-logo.svg", "groq-logo.svg"], (168, 85, 247, 255)),
    ]
    for xy, title, sub, logos, accent in nodes:
        box(d, xy, title, sub, logos, accent=accent)
    arrow(d, (500, 430), (700, 540))
    arrow(d, (700, 600), (500, 490))
    arrow(d, (1120, 570), (1300, 230))
    arrow(d, (1120, 570), (1300, 420))
    arrow(d, (1120, 570), (1300, 610))
    arrow(d, (1120, 570), (1300, 800))
    arrow(d, (1120, 570), (1300, 990))
    arrow(d, (1300, 800), (500, 870))
    label(d, (600, 465), "REST CRUD request")
    label(d, (600, 565), "SSE event stream")
    label(d, (925, 835), "Web push payload")
    save(base, "ch3_13_external_connection_flow.png")


if __name__ == "__main__":
    OUT.mkdir(parents=True, exist_ok=True)
    render_architecture()
    render_smart_routing()
    render_auto_fallback()
    render_tool_registry()
    render_assignment()
    render_external_connection()
