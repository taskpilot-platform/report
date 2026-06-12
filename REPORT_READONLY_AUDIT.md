# READ-ONLY Report Audit

## 1. Audit metadata

- Branch: `fix-report-3.xx`
- Commit hash: `8ae4a5bff747f4a598761cad2656ea3d18c09797`
- Entrypoint: `report/src/main.typ`
- Compile command: `typst compile main.typ report-audit-temp.pdf`
- Compile result: success
- Compile warnings: none emitted to stdout/stderr
- Page count from temporary PDF: 114 physical pages
- Numbered page ranges:
  - Summary: PDF page 15, report page 1
  - Chapter 1: PDF pages 16-21, report pages 2-7
  - Chapter 2: PDF pages 22-37, report pages 8-23
  - Chapter 3: PDF pages 38-104, report pages 24-90
  - Chapter 4: PDF pages 105-109, report pages 91-95
  - Chapter 5: PDF pages 110-112, report pages 96-98
  - References: PDF pages 113-114, report pages 99-100
- Git status before audit: clean, no output from `git status --short`
- Git status after audit: `?? REPORT_READONLY_AUDIT.md`
- Temporary PDF: `report/src/report-audit-temp.pdf`, deleted after audit
- Rendered PNG/contact-sheet files: created only under `%TEMP%`, deleted after audit

Transitive Typst files included from `main.typ`:

`main.typ`, `coverpage.typ`, `lib/metadata.typ`, `thanks.typ`, `glossaries.typ`, `summary.typ`, `chapter1/index.typ`, `chapter2/index.typ`, `chapter2/sections/2_1_project_management.typ`, `chapter2/sections/2_2_ai_agent.typ`, `chapter2/sections/2_3_assignment_algorithm.typ`, `chapter2/sections/2_4_architecture.typ`, `chapter2/sections/2_5_backend.typ`, `chapter2/sections/2_6_frontend.typ`, `chapter2/sections/2_7_storage.typ`, `chapter2/sections/2_8_ai_provider.typ`, `chapter2/sections/2_9_realtime_notification.typ`, `chapter2/sections/2_10_deployment.typ`, `chapter2/sections/2_11_tools.typ`, `chapter3/index.typ`, `chapter3/sections/3_1_overview.typ`, `lib/ui.typ`, `chapter3/sections/3_2_requirements.typ`, `chapter3/sections/3_3_usecase.typ`, `chapter3/sections/3_4_3_5_modeling.typ`, `lib/usecase.typ`, `chapter3/sections/3_6_3_7_architecture.typ`, `chapter3/sections/3_8_database.typ`, `lib/database.typ`, `chapter3/sections/3_9_3_10_realtime_notification.typ`, `chapter3/sections/3_11_ai_copilot.typ`, `chapter3/sections/3_12_assignment_algorithm.typ`, `chapter3/sections/3_13_deployment.typ`, `chapter4/index.typ`, `chapter5/index.typ`, `references.typ`, external package `@preview/codly:1.3.0`.

## 2. Executive summary

- Orphan figure captions: 0 confirmed.
- Orphan table captions: 0 confirmed.
- Heading-orphan issues: 0 confirmed.
- Indentation/alignment issues: 1 global issue.
- Unsupported self-evaluative statements: 13 `REMOVE_OR_REWRITE` findings.
- Context-review statements: 2 `REVIEW_CONTEXT` findings.
- Other visual issues: 5 findings.
- Additional content consistency issues: 2 grouped findings.

The rendered PDF was inspected visually using Typst-generated PNG pages and contact sheets. Normal long-table breaks in the use-case and database sections were not reported unless visually problematic.

## 3. Orphan captions and pagination

| PDF page | Report page | Location | Source | Issue | Severity | Suggested future fix |
| -------: | ----------: | -------- | ------ | ----- | -------- | -------------------- |
| 46 | 32 | Hình 3.39 | `src/chapter3/sections/3_4_3_5_modeling.typ:22-34` | Use Case overview diagram is dense/small; labels are hard to read at normal page size. Caption remains attached. | Medium | Review diagram scale or split by actor after branches merge. |
| 47 | 33 | Paragraph after Hình 3.39 | `src/chapter3/sections/3_4_3_5_modeling.typ:29-34` | Only the final continuation line of the explanatory paragraph appears on the next page, leaving a very large blank region. | Medium | Keep the short paragraph with the previous page or move a following subsection/table upward after merge. |
| 50 | 36 | Hình 3.40 / UC01 sequence | `src/chapter3/sections/3_4_3_5_modeling.typ:389-394` | Sequence diagram is visually small and difficult to read. Caption remains attached. | Medium | Consider cropping whitespace, rotating, or splitting sequence diagrams after merge. |
| 59 | 45 | Hình 3.44 / UC59 sequence | `src/chapter3/sections/3_4_3_5_modeling.typ:600-605` | Sequence diagram is visually small and difficult to read. Caption remains attached. | Medium | Consider a larger render, appendix placement, or textual summary in the main report. |
| 104 | 90 | Hình 3.66 and Hình 3.67 | `src/chapter3/sections/3_13_deployment.typ:93-113` | Three deployment-related figures share the same page; Hình 3.66 and Hình 3.67 are readable only with effort. | Low | Review whether one figure should be enlarged or moved after merge. |

No confirmed case was found where a figure/table caption is separated onto a different page from its object.

## 4. Self-evaluative wording

| Location | Original wording | Classification | Reason | Suggested later rewrite |
| -------- | ----------------- | -------------- | ------ | ----------------------- |
| Summary, PDF 15, `src/summary.typ:22` | "phối hợp công việc hiệu quả hơn" | `REVIEW_CONTEXT` | Comparative value claim without a measured baseline. | "hỗ trợ tổ chức, theo dõi và phối hợp công việc" |
| Chapter 1, PDF 16, `src/chapter1/index.typ:31` | "phân công công việc khách quan dựa trên dữ liệu thực tế" | `REMOVE_OR_REWRITE` | "khách quan" is a strong evaluation; algorithm uses configured weights and heuristics. | "phân công công việc dựa trên dữ liệu kỹ năng, workload và trọng số đã xác định" |
| Chapter 1, PDF 16, `src/chapter1/index.typ:36-37` | "các quy trình Agile được tinh gọn và được hỗ trợ đắc lực" | `REMOVE_OR_REWRITE` | Promotional wording. | "các quy trình Agile được hỗ trợ bởi AI Copilot" |
| Chapter 1, PDF 17, `src/chapter1/index.typ:46-48` | "tối ưu hóa các quy trình quản lý" | `REMOVE_OR_REWRITE` | Optimization is not supported by measurement. | "hỗ trợ một số quy trình quản lý thông qua AI" |
| Chapter 1, PDF 17, `src/chapter1/index.typ:66-67` | "kiến trúc hệ thống hiện đại, đảm bảo tính mở rộng" | `REMOVE_OR_REWRITE` | Broad architecture claim without concrete metric. | "kiến trúc phân module, hỗ trợ bảo trì và mở rộng chức năng ở mức thiết kế" |
| Chapter 1, PDF 20, `src/chapter1/index.typ:181` | "ứng viên phù hợp nhất" | `REMOVE_OR_REWRITE` | "nhất" overstates heuristic recommendation. | "ứng viên được xếp hạng cao theo công thức chấm điểm" |
| Chapter 3, PDF 40, `src/chapter3/sections/3_1_overview.typ:74` | "Vừa đủ cho đồ án" | `REMOVE_OR_REWRITE` | Explicit authorial judgment in comparison table. | "Phạm vi tập trung vào chức năng cốt lõi" |
| Chapter 3, PDF 40, `src/chapter3/sections/3_1_overview.typ:108` | "Phù hợp đồ án" | `REMOVE_OR_REWRITE` | Explicit authorial judgment. | "Triển khai trong phạm vi hệ thống TaskPilot" |
| Chapter 3, PDF 40, `src/chapter3/sections/3_1_overview.typ:112` | "Tinh gọn, tập trung" | `REMOVE_OR_REWRITE` | Promotional tone in comparison table. | "Tập trung vào project, sprint, task, collaboration và AI Copilot" |
| Chapter 3, PDF 61, `src/chapter3/sections/3_6_3_7_architecture.typ:80` | "đảm bảo backend có thể mở rộng tính năng mới dễ dàng" | `REMOVE_OR_REWRITE` | "đảm bảo" and "dễ dàng" are not demonstrated. | "giúp giảm phụ thuộc khi bổ sung module hoặc adapter mới" |
| Chapter 3, PDF 100, `src/chapter3/sections/3_13_deployment.typ:6` | "tối ưu hóa việc quản lý và vận hành" | `REMOVE_OR_REWRITE` | Optimization claim not measured. | "tách frontend, backend và dịch vụ hạ tầng để mô tả rõ trách nhiệm triển khai" |
| Chapter 5, PDF 110, `src/chapter5/index.typ:14` | "tương đối đầy đủ" | `REVIEW_CONTEXT` | May be acceptable in conclusion, but should be checked against implemented scope. | "bao phủ các luồng chính đã triển khai" |
| Chapter 5, PDF 110, `src/chapter5/index.typ:34` | "ở mức phù hợp với phạm vi đồ án" | `REMOVE_OR_REWRITE` | Explicit self-evaluation. | "theo phạm vi triển khai đã xác định" |
| Chapter 5, PDF 111, `src/chapter5/index.typ:52` | "phù hợp với phạm vi đồ án" | `REMOVE_OR_REWRITE` | Explicit self-evaluation. | "giúp giảm chi phí triển khai thử nghiệm" |
| Chapter 5, PDF 112, `src/chapter5/index.typ:73` | "phù hợp với phạm vi đồ án hơn là vận hành quy mô lớn" | `REMOVE_OR_REWRITE` | The contrast is useful, but phrase should be neutral. | "phục vụ triển khai thử nghiệm hơn là vận hành quy mô lớn" |

## 5. Paragraph indentation and left alignment

| PDF page | Chapter/section | First words / scope | Source | Likely cause | Severity | Suggested future correction |
| -------: | --------------- | ------------------- | ------ | ------------ | -------- | --------------------------- |
| 15-112 | Body prose throughout numbered report pages | Many normal body paragraphs begin with a first-line indent. | `src/main.typ:34-41` | Global `#set par(first-line-indent: (amount: 1em, all: false))` conflicts with audit style requiring no first-line indentation. | Medium | After branch merge, decide whether to remove or override first-line indentation globally. Do not change shared paragraph settings before merge. |

## 6. Other findings

- `Vercel` still appears in rendered/source content even though the final deployment stack is expected to use Netlify: `src/chapter3/sections/3_2_requirements.typ:49`, `src/chapter3/sections/3_3_usecase.typ:76`, `src/chapter3/sections/3_13_deployment.typ:57`, `src/chapter5/index.typ:37`, and `src/references.typ:67-68`. Chapter 2 also has a Vercel technology subsection (`src/chapter2/sections/2_10_deployment.typ:34-42`).
- `Use Case`, `Use case`, and `use case` appear with inconsistent capitalization across `src/summary.typ`, `src/chapter1/index.typ`, `src/chapter3/sections/3_2_requirements.typ`, `src/chapter3/sections/3_4_3_5_modeling.typ`, `src/chapter3/sections/3_11_ai_copilot.typ`, and `src/chapter4/index.typ`.
- No rendered `Compatibility label` text was found.
- No rendered `CoT`, `chain-of-thought`, or `Notopia` text was found.
- `TODO` appears only as a task status enum/default value in the database section (`src/chapter3/sections/3_8_database.typ:140` and `:424`), not as a visible debug marker.

## 7. Findings grouped by source file

- `src/main.typ`
  - Global paragraph indentation conflicts with the requested no-indent body prose style.
  - Merge label: `LIKELY_SHARED_FILE`, `GLOBAL_HELPER_RISK`
- `src/summary.typ`
  - Comparative wording "hiệu quả hơn".
  - `use case` casing occurrence.
  - Merge label: `LIKELY_SHARED_FILE`
- `src/chapter1/index.typ`
  - Promotional/self-evaluative wording: "khách quan", "tinh gọn", "đắc lực", "tối ưu hóa", "hiện đại", "đảm bảo", "phù hợp nhất".
  - `Use Case` casing occurrence.
  - Vercel appears in technology table.
  - Merge label: `SAFE_AFTER_MERGE`
- `src/chapter2/sections/2_10_deployment.typ`
  - Vercel subsection remains; review if final stack is Netlify-only.
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter3/sections/3_1_overview.typ`
  - Comparison table has self-evaluative cells: "Vừa đủ cho đồ án", "Phù hợp đồ án", "Tinh gọn, tập trung".
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter3/sections/3_2_requirements.typ`
  - `Use Case` casing occurrences.
  - Netlify/Vercel deployment wording.
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter3/sections/3_3_usecase.typ`
  - Netlify/Vercel deployment wording.
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter3/sections/3_4_3_5_modeling.typ`
  - Use Case overview diagram is visually dense.
  - One-line continuation and large blank area after Hình 3.39.
  - Several sequence diagrams are visually small.
  - `Use Case/use case/Use case` casing is mixed.
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter3/sections/3_6_3_7_architecture.typ`
  - Self-evaluative wording around "đảm bảo" and "dễ dàng".
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter3/sections/3_13_deployment.typ`
  - Optimization wording.
  - Netlify/Vercel deployment wording.
  - Dense small deployment figures on PDF page 104.
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter4/index.typ`
  - `use case` casing occurrences.
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/chapter5/index.typ`
  - Self-evaluative "phù hợp với phạm vi đồ án" wording.
  - Netlify/Vercel wording.
  - Merge label: `CONTRIBUTOR_OWNED_SECTION`
- `src/references.typ`
  - Vercel reference remains; remove only if all Vercel citations are removed after merge.
  - Merge label: `LIKELY_SHARED_FILE`

## 8. Merge-conflict risk map

- `GLOBAL_HELPER_RISK`: `src/main.typ` paragraph style. Do not change before merge because it affects all chapters.
- `LIKELY_SHARED_FILE`: `src/summary.typ`, `src/references.typ`. These are likely touched by multiple contributors and should be edited after the merged content is stable.
- `CONTRIBUTOR_OWNED_SECTION`: Chapter 2, Sections 3.1-3.5, Section 3.13, Chapter 4, Chapter 5. Local fixes are safer after the corresponding contributor branch lands.
- `SAFE_AFTER_MERGE`: Chapter 1 wording cleanup can be done after source ownership is clear.

## 9. Recommended post-merge repair order

1. Merge contributor branches.
2. Compile a clean baseline from `report/src/main.typ`.
3. Resolve content conflicts and confirm final deployment stack wording.
4. Fix local self-evaluative wording in Chapter 1, Chapter 3, and Chapter 5.
5. Fix local caption/page issues in Section 3.4/3.5 and Section 3.13.
6. Apply a global paragraph-style change only if the merged PDF confirms no-indent body prose is still required.
7. Normalize `Use Case/use case/Use case` spelling.
8. Remove Vercel references and bibliography entry only if no remaining citation uses Vercel.
9. Run final bibliography and visual audit.

## 10. Uncertain findings

- Text inside image assets was not OCR-audited. Visual readability was checked, but unsupported wording embedded in diagrams may still require manual review.
- The audit reports representative small sequence diagrams rather than every dense diagram instance; Section 3.5 should be reviewed as a group after merge.
- Vercel is flagged because the audit brief says the final stack uses Netlify. If contributors intentionally keep Vercel as an alternative deployment target, these occurrences should be reclassified as `REVIEW_CONTEXT`.

## Critical numbering issues

Expected rule for rendered captions: figures use `Hình <chapter>.<index within chapter>` and tables use `Bảng <chapter>.<index within chapter>`. The second number must restart from 1 at the beginning of each chapter. Figure and table counters are independent, but both must reset by chapter.

Rendered PDF baseline used for this extension: temporary compile of `src/main.typ` to `%TEMP%\taskpilot-counter-audit.pdf`, 114 physical PDF pages. Numbered report pages begin at PDF page 15, so report page = PDF page - 14 for numbered content.

| Chapter | Object type | Actual first number | Expected first number | Source/helper likely involved | Severity |
| --- | --- | --- | --- | --- | --- |
| Chapter 1 | Figure | None detected | N/A | N/A | N/A |
| Chapter 1 | Table | `Bảng 1.1` | `Bảng 1.1` | `src/main.typ` figure numbering | OK |
| Chapter 2 | Figure | `Hình 2.1` | `Hình 2.1` | `src/main.typ` figure numbering | OK |
| Chapter 2 | Table | `Bảng 2.2` | `Bảng 2.1` | `src/main.typ` figure numbering; `figure.where(kind: table)` caption setup | `CRITICAL_COUNTER_RESET` |
| Chapter 3 | Figure | `Hình 3.31` | `Hình 3.1` | `src/main.typ` figure numbering | `CRITICAL_COUNTER_RESET` |
| Chapter 3 | Table | `Bảng 3.3` | `Bảng 3.1` | `src/main.typ` figure numbering; `src/lib/ui.typ` table figure helper | `CRITICAL_COUNTER_RESET` |
| Chapter 4 | Figure | `Hình 4.68` | `Hình 4.1` | `src/main.typ` figure numbering; Chapter 4 UI figure helpers | `CRITICAL_COUNTER_RESET` |
| Chapter 4 | Table | `Bảng 4.49` | `Bảng 4.1` | `src/main.typ` figure numbering; `src/lib/ui.typ` table figure helper | `CRITICAL_COUNTER_RESET` |
| Chapter 5 | Figure | None detected | N/A | N/A | N/A |
| Chapter 5 | Table | None detected | N/A | N/A | N/A |

Additional numbering observations:

- No duplicated rendered caption numbers were detected in the extracted caption list.
- The rendered order of captions is mostly monotonically increasing under the current global counter, except the Section 3.8 table interleaving described below.
- Under the expected chapter-local rule, the report has large missing initial ranges: for example Chapter 3 starts at `Hình 3.31` instead of `Hình 3.1`, and Chapter 4 starts at `Hình 4.68` instead of `Hình 4.1`.
- The generated List of Figures and List of Tables should not be treated as validation for the current numbering. They inherit the same rendered caption numbers, so they can appear internally consistent while still violating the chapter-local restart rule.

## Float interleaving and rendered-order issues

| PDF page | Report page | Current rendered order | Intended reading order | Source file | Severity | Suggested later investigation |
| --- | --- | --- | --- | --- | --- | --- |
| 68-70 | 54-56 | `Hình 3.50` -> `Bảng 3.18` begins -> `Bảng 3.16` -> continuation rows of `Bảng 3.18` -> `Bảng 3.17` -> final row of `Bảng 3.18` -> `Bảng 3.19` | Keep the Section 3.8 overview objects in source order: `Hình 3.50`, `Bảng 3.16`, `Bảng 3.17`, then the detailed `users` table; or, once `Bảng 3.18` begins, keep all of its fragments consecutive before rendering unrelated tables. | `src/chapter3/sections/3_8_database.typ` | `CRITICAL_FLOAT_INTERLEAVING`; `INTERRUPTED_LONG_TABLE`; `OUT_OF_ORDER_TABLE` | Inspect `src/lib/database.typ` and `src/lib/ui.typ` table figure wrappers, especially `breakable` and `placement` behavior around `db-table-figure` and `ui-table-figure`. |

Notes:

- The problem is not merely whether each caption remains visually attached to its own table. The complete reading order is incoherent because later overview tables are inserted into the continuation of an earlier long table.
- `Bảng 3.18` is rendered before lower-numbered `Bảng 3.16` and `Bảng 3.17`, so the visual table order is not monotonically increasing within Chapter 3.
- The source order around Section 3.8 places the database grouping table and enum table before the detailed `users` table, but the rendered output floats/interleaves them after `Bảng 3.18` has already started.

## Long-table continuation issues

| Object | PDF pages | Report pages | Continuation integrity | Severity | Notes |
| --- | --- | --- | --- | --- | --- |
| `Bảng 3.18: Mô tả chi tiết bảng users` | 68-70 | 54-56 | Failed: continuation rows are not consecutive; unrelated `Bảng 3.16` and `Bảng 3.17` appear between fragments. | `CRITICAL_FLOAT_INTERLEAVING`; `INTERRUPTED_LONG_TABLE`; `OUT_OF_ORDER_TABLE` | Caption appears once and headers repeat on fragments, but the table is visually mixed with other tables. The following table `Bảng 3.19` begins only after the final `users` row, but the two overview tables have already interrupted the long table. |

Other continuation observations:

- No additional confirmed case was found where another unrelated figure/table is inserted between fragments of a long use-case, database, or deployment/component table.
- Multi-page table checks should be repeated after any future float/helper change, because the current issue is produced by shared table wrappers rather than by isolated caption text.
- For long database specification tables, caption attachment alone is insufficient. The rendered row sequence must remain consecutive and should not be interrupted by overview tables or unrelated figures.

## Likely shared helpers involved

- `src/main.typ`: global `#set figure(numbering: ...)` uses the current heading number plus `num.pos().first()`. This appears to produce chapter labels with globally continuing figure/table indices instead of chapter-local indices.
- `src/main.typ`: `#show figure.where(kind: table): set figure.caption(position: top)` affects table captions globally. It is not itself a reset mechanism.
- `src/lib/ui.typ`: `ui-table-figure` wraps tables in `figure(...)` and sets block breakability through `show figure: set block(breakable: breakable)`. This is likely involved in table float and continuation behavior across the report.
- `src/lib/database.typ`: `db-table-figure` defaults to `breakable: true` and `placement: none`, then delegates to `ui-table-figure`. This is directly involved in long database specification tables such as `Bảng 3.18`.
- `src/chapter3/sections/3_8_database.typ`: source order places `Bảng 3.16` and `Bảng 3.17` before the detailed `users` table, but rendered order interleaves those overview tables into the `Bảng 3.18` continuation.
