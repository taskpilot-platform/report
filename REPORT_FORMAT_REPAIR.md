# Report Formatting Repair

## Baseline

- Branch: `fix-report-3.xx`
- Commit before repair: `8ae4a5bff747f4a598761cad2656ea3d18c09797`
- Entrypoint: `report/src/main.typ`
- Baseline compile command: `typst compile main.typ report-before-format-fix.pdf`
- Baseline compile result: success
- Body font size from `src/main.typ`: `13pt`
- Initial physical page count: 114
- Initial numbered page count: 100
- Precondition status:
  - No unresolved merge-conflict paths were reported by `git status --short`.
  - No conflict markers were found in included Typst source under `src`.
  - Existing untracked file before this pass: `REPORT_READONLY_AUDIT.md`.
  - `git branch --no-merged` listed `test`; no active merge conflict was present.

## Table font policy applied

- Default table text size: `13pt` (`BODY_SIZE`).
- Compact table text size: `12pt` (`BODY_SIZE - 1pt`).
- Absolute minimum table text size: `11pt` (`BODY_SIZE - 2pt`).
- Tables using compact mode:
  - `Bảng 2.1: So sánh Monolith truyền thống, Modular Monolith và Microservices` - `12pt`, reduction `-1pt`.
  - `Bảng 3.1: So sánh các công cụ quản lý dự án và định hướng của TaskPilot` - `12pt`, reduction `-1pt`.
  - `Bảng 3.6: Tổng hợp danh sách 59 use case của hệ thống TaskPilot` - `12pt`, reduction `-1pt`.
- Tables using the absolute minimum: none.
- Database table body text uses `13pt`; raw/code-like identifiers inside database tables use `12pt` for wrapping and readability.
- No complete table is intentionally scaled, resized, fit into a fixed-height box, or shrunk to one page.

## Helpers modified

| Helper/file | Old behavior | New behavior |
| --- | --- | --- |
| `src/lib/report-style.typ` | Not present. | Defines shared `body_size`, `table_body_size`, `table_compact_size`, `table_min_size`, and `table_raw_size`. |
| `src/main.typ` | Body size was literal `13pt`; normal paragraphs had `first-line-indent: 1em`; figure/table numbering used the chapter number plus a globally continuing counter. | Body size comes from shared style; normal prose has no first-line indent; figure, table and raw figure counters reset at each numbered chapter heading. |
| `src/lib/ui.typ` | `ui-table-figure` defaulted to `placement: auto` and had no explicit table text-size policy. | `ui-table-figure` defaults to `placement: none`, applies `13pt` by default, and exposes `compact: true` / `text-size` for reviewed exceptions. |
| `src/lib/database.typ` | Database tables defaulted to `8pt` body text and `7pt` raw text. | Database tables default to `13pt` body text and `12pt` raw/code text, remain breakable, and keep white backgrounds/borders. |
| `src/lib/usecase.typ` | Use-case specification tables inherited surrounding styles without a shared size policy. | Use-case specification tables default to `13pt`, with optional compact mode available but not used by default. |

## Tables repaired

| Table/location | Old problem | Final text size | Pagination behavior |
| --- | --- | --- | --- |
| Chapter 1 technology table | Kept as a normal table but affected by global numbering/indent issues. | `13pt` | Fits on one page; caption remains above. |
| `Bảng 2.1` architecture comparison | Previously forced to `9pt`. | `12pt` compact | Breakable helper; stays readable and in source order. |
| `Bảng 3.1` product comparison | Previously forced to `11pt` and contained self-evaluative cells. | `12pt` compact | Breakable helper; readable with wrapped cells. |
| `Bảng 3.4` system components | Previously forced to `8.6pt`. | `13pt` | Breakable; no complete-table scaling. |
| `Bảng 3.5` frontend layers | Previously forced to `11pt`. | `13pt` | Normal table figure; caption remains above. |
| `Bảng 3.6` 59 use cases | Previously forced to `8pt` and visually too small. | `12pt` compact | Spans multiple pages with header continuation; no row/content removed. |
| Section 3.5 use-case specification tables | Needed readable wrapping and natural continuation. | `13pt` | Long specifications continue naturally; no complete specification is squeezed into one page. |
| Section 3.8 database specification tables | Previously `8pt`/`7pt`; `users` table continuation was interrupted by unrelated tables. | `13pt` body, `12pt` raw identifiers | Long tables continue in source order; overview tables render before detailed database tables. |
| Section 3.12 algorithm tables | Kept approved formulas and values; checked for table readability. | `13pt` | Representative AHP/mode/example tables remain readable. |
| Chapter 4 UI description tables | Previously forced to `10pt`. | `13pt` | Tables may move to following pages; readability prioritized. |

## Structural fixes

- Chapter-local counter fix:
  - Figures now restart per chapter: Chapter 3 starts at `Hình 3.1`; Chapter 4 starts at `Hình 4.1`.
  - Tables now restart per chapter: Chapter 2 starts at `Bảng 2.1`; Chapter 3 starts at `Bảng 3.1`; Chapter 4 starts at `Bảng 4.1`.
  - Figure and table counters remain automatic and independent.
- Section 3.8 interleaving fix:
  - Rendered order is now `Hình 3.20`, `Bảng 3.14`, `Bảng 3.15`, complete `Bảng 3.16 users`, then `Bảng 3.17 refresh_tokens` and following database tables.
  - No unrelated table interrupts the `users` table continuation.
- Caption checks:
  - Table captions remain above tables.
  - Figure captions remain below figures.
  - No complete table was scaled to page width.
- Paragraph indentation fix:
  - Normal body prose now begins at the same left edge with no first-line indent.
  - Lists, tables, captions, outlines and references keep their own structural indentation.

## Content consistency fixes

- Self-evaluative wording:
  - Rewrote unsupported comparative/promotional phrases such as "hiệu quả hơn", "khách quan", "tinh gọn", "đắc lực", "tối ưu hóa", "hiện đại", "đảm bảo tính mở rộng", "phù hợp nhất", "Vừa đủ cho đồ án", "Phù hợp đồ án" and "phù hợp với phạm vi đồ án" into neutral technical wording.
- Vercel decision:
  - Final frontend platform treated as Netlify based on production configuration and existing report direction.
  - Removed the Chapter 2 Vercel subsection and rendered Vercel figure.
  - Removed Vercel from Chapters 1, 3 and 5.
  - Removed the Vercel bibliography entry after confirming no remaining report citation uses it.
  - Regenerated the deployment SVG/PNG assets through the existing `_incoming/scripts` icon-rich pipeline so the deployment diagrams keep their logo-based visual style while showing Netlify only for frontend deployment.
- Use-case capitalization:
  - Normal prose was normalized to `use case`.
  - Title-style `Use Case` remains only in Vietnamese headings/captions where it functions as a formal section/diagram label.

## Final verification

- Final compile command: `typst compile main.typ report-after-format-fix.pdf`
- Final compile result: success
- Final physical pages: 126
- Final numbered pages: 112
- Rendered verification method:
  - Extracted captions from the final PDF with bundled `pypdf`.
  - Rendered selected table-heavy pages to PNG with Typst at 120 PPI.
  - Visually inspected contact sheets for use-case tables, database tables, algorithm/deployment tables, Chapter 4 UI tables and early comparison tables.
- Counter verification:
  - Chapter 1 table first: `Bảng 1.1`
  - Chapter 2 figure/table first: `Hình 2.1`, `Bảng 2.1`
  - Chapter 3 figure/table first: `Hình 3.1`, `Bảng 3.1`
  - Chapter 4 figure/table first: `Hình 4.1`, `Bảng 4.1`
- Remaining unreadable or uncertain pages:
  - No unreadable table pages confirmed after the repair.
  - Some sequence diagrams remain visually dense/small; they were already audit findings and were not table-formatting targets in this pass.
