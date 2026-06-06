from pathlib import Path
from PIL import Image

INPUT_DIR = Path(r"D:\HK6-UIT\DA1\report\_incoming\asset\chapter4")
OUTPUT_DIR = INPUT_DIR / "cropped"
OUTPUT_DIR.mkdir(exist_ok=True)

# Điều chỉnh nếu cần
TOP = 109
BOTTOM_CUT = 60
LEFT = 0
RIGHT_CUT = 0

for img_path in INPUT_DIR.glob("*.png"):
    img = Image.open(img_path)
    w, h = img.size

    cropped = img.crop((
        LEFT,
        TOP,
        w - RIGHT_CUT,
        h - BOTTOM_CUT
    ))

    out_path = OUTPUT_DIR / img_path.name
    cropped.save(out_path)

    print(f"{img_path.name}: {img.size} -> {cropped.size}")