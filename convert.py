import re
import sys

def convert_md_to_typst(md_path, typ_path):
    with open(md_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    out = []
    # Only import what we need
    out.append('#import "../../lib/ui.typ": ui-table-figure\n')
    out.append('\n')

    i = 0
    in_db_table = False
    db_cols = []
    
    in_normal_table = False
    normal_table_rows = []
    normal_table_headers = []

    def flush_normal_table():
        if not normal_table_rows and not normal_table_headers:
            return ""
        
        cols = len(normal_table_headers)
        res = f"#ui-table-figure(\n  caption: none,\n  table(\n    columns: {cols},\n    align: left,\n    stroke: 0.5pt,\n"
        
        res += "    table.header(" + ", ".join(f"[{h}]" for h in normal_table_headers) + "),\n"
        
        for row in normal_table_rows:
            res += "    " + ", ".join(f"[{c}]" for c in row) + ",\n"
        res += "  )\n)\n"
        return res

    while i < len(lines):
        line = lines[i].strip()
        
        if line.startswith('## '):
            title = re.sub(r'^##\s+\d+\.\d+\.\s*', '', line)
            out.append(f"== {title}\n")
        elif line.startswith('### '):
            title = re.sub(r'^###\s+\d+\.\d+\.\d+\.\s*', '', line)
            out.append(f"=== {title}\n")
        elif line.startswith('#### '):
            title = re.sub(r'^####\s+\d+\.\d+\.\d+\.\d+\.\s*', '', line)
            out.append(f"==== {title}\n")
        elif line.startswith('| STT | Thuộc tính'):
            in_db_table = True
            db_cols = []
            i += 1 
        elif in_db_table and line.startswith('|'):
            parts = [p.strip() for p in line.strip('|').split('|')]
            if len(parts) >= 5:
                name, typ, constraint, desc = parts[1], parts[2], parts[3], parts[4]
                db_cols.append(f"    column([{name}], [{typ}], [{constraint}], [{desc}])")
        elif in_db_table and not line.startswith('|'):
            in_db_table = False
            caption = "none"
            j = i
            while j < len(lines):
                peek = lines[j].strip()
                if peek.startswith('Bảng x:'):
                    caption = f"[{peek[7:].strip()}]"
                    i = j
                    break
                elif peek != "":
                    break
                j += 1
            
            out.append(f"#db-table-figure(\n  caption: {caption},\n" + ",\n".join(db_cols) + "\n)\n")
            if i != j:
                if line:
                    out.append(f"{line}\n")
        elif line.startswith('|') and i+1 < len(lines) and '---' in lines[i+1]:
            normal_table_headers = [p.strip() for p in line.strip('|').split('|')]
            in_normal_table = True
            normal_table_rows = []
            i += 1 
        elif in_normal_table and line.startswith('|'):
            parts = [p.strip() for p in line.strip('|').split('|')]
            normal_table_rows.append(parts)
        elif in_normal_table and not line.startswith('|'):
            in_normal_table = False
            out.append(flush_normal_table())
            normal_table_headers = []
            normal_table_rows = []
            if line:
                out.append(f"{line}\n")
        elif line.startswith('[Hình x:'):
            caption = line[8:-1].strip()
            # Use rect instead of image to prevent compile error
            out.append(f'#figure(rect(width: 100%, height: 150pt, align(center + horizon)[TODO: {caption}]), caption: [{caption}])\n')
        elif line:
            if not line.startswith('Bảng x:'):
                out.append(f"{line}\n")
        else:
            out.append("\n")
            
        i += 1

    if in_normal_table:
        out.append(flush_normal_table())

    with open(typ_path, 'w', encoding='utf-8') as f:
        f.writelines(out)

if __name__ == '__main__':
    convert_md_to_typst(sys.argv[1], sys.argv[2])
