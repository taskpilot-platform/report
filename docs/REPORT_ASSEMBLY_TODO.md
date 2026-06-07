# REPORT_ASSEMBLY_TODO.md

## Compile check

- [x] Detected Typst entrypoint: `src/main.typ`.
- [x] Ran compile check from `report/src`: `typst compile main.typ report.pdf`.
- [x] Compile status: success.
- [x] Ran compile check after Chapter 1 conversion: success.
- [x] Ran compile check after Chapter 5 conversion: success.
- [x] Ran compile check after Chapter 4 conversion: success.
- [x] Ran compile check after replacing Chapter 4 navigation SVG with PNG and adding bordered UI figures: success.
- [x] Ran compile check after re-rendering the Chapter 4 UI navigation flow with English labels: success.
- [x] Ran compile check after switching the Chapter 4 UI navigation flow back to SVG rendered from Graphviz: success.
- [x] Ran compile check after Chapter 2 conversion: success.
- [x] Ran compile check after converting Chapter 3 sections 3.4.1 through 3.4.3: success.
- [x] Ran compile check after converting Chapter 3 sections 3.4.4 through the first detailed use case UC01: success.
- [x] Ran compile check after converting the rest of Chapter 3 section 3.5: success.
- [x] Ran compile check after refactoring Chapter 3 section 3.5 to representative use cases only: success.
- [ ] Resolve warning if required later:

```text
warning: unknown font family: svn-times new roman 2
   ┌─ \\?\D:\HK6-UIT\DA1\report\src\main.typ:20:8
   │
20 │   font: "SVN-Times New Roman 2",
   │         ^^^^^^^^^^^^^^^^^^^^^^^
```

- [x] Resolved Chapter 4 navigation diagram warning by replacing the Mermaid SVG with a Graphviz-rendered SVG that has `foreignObject=False`.
- [ ] Review Chapter 2 SVG `foreignObject` warnings if the final PDF renders those diagrams incorrectly:

```text
warning: image contains foreign object
src/chapter2/sections/2_2_ai_agent.typ:41: ch2_04_function_calling.svg
src/chapter2/sections/2_2_ai_agent.typ:59: ch2_05_human_in_the_loop.svg
src/chapter2/sections/2_3_assignment_algorithm.typ:12: ch2_06_weighted_scoring_ahp.svg
```

## Assembly checklist

- [x] Compile existing template.
- [ ] Add/adjust frontmatter only after confirming whether `src/main.typ` ordering may be changed.
- [x] Convert/insert Chapter 1 from `_incoming/CHAPTER_1_FINAL.md`.
- [x] Convert/insert Chapter 2 from `_incoming/CHAPTER_2_FINAL.md`.
- [ ] Convert/insert Chapter 3 from `_incoming/CHAPTER_3_*_FINAL.md` files.
  - [x] Prepare split structure under `src/chapter3/sections/`.
  - [x] Convert/insert sections 3.1, 3.2, and 3.3.
  - [x] Convert/insert sections 3.4.1 through 3.4.3.
  - [x] Convert/insert sections 3.4.4 through the first detailed use case UC01.
  - [x] Convert/insert the rest of section 3.5 from UC02 through the final use case notes.
  - [x] Refactor section 3.5 to render only representative use cases; repetitive CRUD/list/update flows remain covered by the 3.4 use case summary and external/full documentation note.
  - [ ] Continue converting Chapter 3 sections 3.6 through 3.13.
- [x] Convert/insert Chapter 4 from `_incoming/CHAPTER_4_FINAL.md`.
- [x] Convert/insert Chapter 5 from `_incoming/CHAPTER_5_1_5_2_FINAL.md` and `_incoming/CHAPTER_5_3_5_4_FINAL.md`.
- [ ] Fix image paths after deciding final asset destination under `src/assets`.
- [ ] Fix figure/table captions using existing Typst figure conventions.
- [ ] Compile PDF after each major chapter insertion.
- [ ] Review TODOs and missing assets from `_incoming/PLACEHOLDER_ASSET_STATUS.md`.
- [x] Audit Chapter 3 placeholders and assets before conversion.
- [x] Redraw the six user-flagged Chapter 3 sequence diagrams and the project access permission diagram as Mermaid-rendered SVG assets.
- [ ] Review final page layout for wide tables, oversized diagrams, and screenshot scaling.
- [ ] Review bibliography/reference citations after content insertion.
- [ ] Consolidate temporary/plain-text references into the final end-of-report bibliography; do not leave per-section reference blocks inside chapters.
- [ ] Add italic chapter introduction summaries for Chapters 3, 4, and 5 to match the Chapter 1/2 style.
- [ ] Reconcile List of Tables after final layout: long Chapter 3 tables are currently breakable direct tables with manual captions, so they may not appear automatically in the generated table list.

## Chapter 1 notes

- Converted into `src/chapter1/index.typ`.
- Kept Chapter 1 as one Typst file.
- No images were referenced by `_incoming/CHAPTER_1_FINAL.md`.
- No Chapter 1 missing assets were identified.
- Final technology table compiles as a regular Typst `table`.

## Chapter 5 notes

- Converted into `src/chapter5/index.typ`.
- Concatenated `_incoming/CHAPTER_5_1_5_2_FINAL.md` then `_incoming/CHAPTER_5_3_5_4_FINAL.md`.
- Kept Chapter 5 as one Typst file.
- No images, tables, code blocks, or citations were present in the Chapter 5 drafts.
- No Chapter 5 missing assets were identified.

## Chapter 4 notes

- Converted into `src/chapter4/index.typ`.
- Kept Chapter 4 as one Typst file.
- Copied the navigation diagram and cropped UI screenshots into `src/assets/taskpilot/chapter4/`.
- Used `#ui-figure(...)` for Chapter 4 figures.
- `src/lib/ui.typ` now wraps `ui-figure` images with a white background, light `0.5pt` border, `4pt` radius, and `3pt` inset.
- Converted component description tables into local Typst table figures.
- No Chapter 4 missing assets were identified.
- Compile succeeded after switching the navigation diagram to PNG, then again after switching back to a clean SVG.
- Re-rendered `taskpilot_ui_navigation_flow.png` with English labels and updated the Chapter 4 asset copy.
- Re-rendered `taskpilot_ui_navigation_flow.svg` from `_incoming/asset/assets/diagrams/taskpilot_ui_navigation_flow.dot`; Chapter 4 now uses this SVG because it is vector-sharp and `foreignObject=False`.

## Chapter 2 notes

- Converted `src/chapter2/index.typ` to include only the requested major section files under `src/chapter2/sections/`.
- Left old technology-split Chapter 2 files in place but no longer included them from `src/chapter2/index.typ`.
- Copied required Chapter 2 assets into `src/assets/taskpilot/chapter2/`.
- Converted 27 image placeholders and 1 comparison table.
- Hình 2.14 is rendered from the four copied logo files because Typst cannot load linked SVG images inside `ch2_14_frontend_supporting_libs.svg`.
- Updated Chapter 2 logo figures:
  - Spring Data JPA and Flyway are rendered side by side.
  - Gemini uses a cropped star-only logo asset.
  - Supabase Storage, GitHub Models/OpenAI-compatible API, and Groq figures were added from available assets.
- The Markdown `Tài liệu tham khảo` block was not inserted as a Chapter 2 section; citations such as `[1]`, `[2]` remain plain text for later bibliography cleanup.
- Added temporary compatibility labels in `src/chapter2/index.typ` so old Chapter 3/appendix references still compile until those chapters are converted.
- Compile succeeded with three SVG `foreignObject` warnings for Chapter 2 diagrams.

## Chapter 3 asset audit

- Created `docs/CHAPTER3_ASSET_AUDIT.md`.
- Found 70 Chapter 3 image placeholders and 70 matching tracker rows.
- Checked 79 real asset references from the tracker; no missing files were identified.
- The six user-flagged sequence diagrams are currently mapped to explicit Chapter 3 placeholders and should not be deleted before conversion.
- Use the flagged sequence diagrams only for exact sequence/flow placeholders; prefer higher-level diagrams for overview placeholders.
- `sequence-ai-pending-action-confirmation.svg` is mapped twice and should be reviewed for duplicate visual clutter during Chapter 3 assembly.
- Redrew the six user-flagged sequence diagrams and `activity-project-access-permission-check.svg` with Mermaid source files beside the SVG files.
- Re-rendered all seven SVG assets in place with English labels and checked them for `foreignObject`; all seven returned `False`.
- `activity-project-access-permission-check.svg` is rendered from Mermaid sequence syntax in the activity asset path because Mermaid flowchart/state output still generated `foreignObject`.

## Chapter 3 partial conversion notes

- Replaced the old Chapter 3 wrapper with `src/chapter3/index.typ` including the requested `src/chapter3/sections/` files in order.
- Converted only:
  - `src/chapter3/sections/3_1_overview.typ` from `_incoming/CHAPTER_3_1_FINAL.md`.
  - `src/chapter3/sections/3_2_requirements.typ` from `_incoming/CHAPTER_3_2_FINAL.md`.
  - `src/chapter3/sections/3_3_usecase.typ` from `_incoming/CHAPTER_3_3_FINAL.md`.
- Left sections 3.4 through 3.13 as minimal heading/TODO placeholders.
- Copied assets used by sections 3.1 through 3.3 into `src/assets/taskpilot/chapter3/`.
- No missing assets were identified for sections 3.1 through 3.3.
- Removed the temporary reference block from section 3.1 so references remain a final-report cleanup task.
- Re-rendered `ch3_01_jira_workflow.svg` and `ch3_01_trello_kanban.svg` from Graphviz/DOT; both now have `foreignObject=False`.
- Added real UI JPEG figures for Jira, Trello, and Asana in section 3.1.
- Removed local font-size overrides from Chapter 3 tables in sections 3.1 and 3.3.
- Converted long Chapter 3 tables in sections 3.1 and 3.3 from `figure(table(...))` to breakable direct `table(...)` blocks with one manual caption each.
- Converted only sections 3.4.1 through 3.4.3 in `src/chapter3/sections/3_4_3_5_modeling.typ`.
- Copied and used these use case diagrams under `src/assets/taskpilot/chapter3/`:
  - `use-case-system.svg`
  - `use-case-admin.svg`
  - `use-case-pm.svg`
  - `use-case-member.svg`
- Converted sections 3.4.4, 3.4.5, 3.4.6, the 3.5 introduction, and the first detailed use case UC01 in `src/chapter3/sections/3_4_3_5_modeling.typ`.
- Copied and used `sequence-auth-login.svg` under `src/assets/taskpilot/chapter3/`.
- `usecase(...)` and `usecase-figure(...)` were used without patching `src/lib/usecase.typ`.
- `typst query main.typ "figure.where(kind: table)" --field caption --format json` shows `Mô tả use case Đăng nhập hệ thống` as `kind: table`; no helper patch is needed for the converted use case specification table.
- Removed the draft-only sample use case specification from the report; it was only a conversion guide.
- The direct breakable table `Bảng 3.4: Bảng tổng hợp danh sách 59 use case của hệ thống TaskPilot` may not appear automatically in the List of Tables and should be reconciled during final cleanup.
- Converted the rest of section 3.5 from `UC02 - Đăng ký tài khoản` through `3.5.8. Ghi chú về đặc tả Use Case đầy đủ`.
- Copied and used all sequence diagrams referenced by the remaining section 3.5 placeholders under `src/assets/taskpilot/chapter3/`.
- Kept sequence diagrams before each corresponding use case specification table.
- Added local `uc-sequence(...)` helper in `src/chapter3/sections/3_4_3_5_modeling.typ` so each use case title stays with its first sequence diagram.
- Used `usecase(...)` and `usecase-figure(...)` for all section 3.5 specification tables without patching `src/lib/usecase.typ`.
- `typst query main.typ "figure.where(kind: table)" --field caption --format json` shows the converted section 3.5 use case specification tables as `kind: table`; no helper patch is needed.
- Replaced `sequence-ai-pending-action-confirmation.svg` with a PlantUML-rendered SVG from `_incoming/asset/assets/sync-diagrams/sequence/sequence-ai-pending-action-confirmation.puml`.
- Updated the PlantUML source for `sequence-ai-pending-action-confirmation.svg` to use explicit activation/deactivation bars matching the `taskpilot-platform.github.io` sequence diagram style.
- Removed the draft note under the AI pending action confirmation figure.
- Refactored section 3.5 so the main report renders only representative use cases:
  - UC01, UC03/UC04, UC23, UC31, UC44, UC46, UC47, UC50, UC56, UC59, and AI pending action confirmation.
- Removed rendering from section 3.5 for repetitive/non-representative detailed flows, including UC02, UC26, UC32, UC36, UC40, UC53, UC54, UC55, UC58, UC13, UC14-UC17, and UC18-UC21.
- Kept the complete 59-use-case summary table in section 3.4 and added/kept notes that full use case specifications, sequence diagrams, and activity diagrams are referenced in project documentation/appendix.
- After refactor, `typst query main.typ "figure.where(kind: image)" --field caption --format json` and `typst query main.typ "figure.where(kind: table)" --field caption --format json` show only the representative section 3.5 sequence/table captions in the generated figure/table lists.
- Approximate compiled page range for section 3.5 after refactor: pages 82-101; the next section starts on page 102.

## Notes for next assembly run

- Do not rewrite chapter content during conversion; preserve technical meaning.
- Keep template/page/font/heading config unchanged unless the user explicitly asks for a formatting patch.
- Prefer cropped Chapter 4 screenshots from `_incoming/asset/chapter4/cropped` if the full screenshots are too large.
- Record missing images near their future Typst figure locations instead of deleting placeholders.
