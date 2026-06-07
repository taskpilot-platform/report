# TYPST_STRUCTURE_CONTEXT.md

## 1. Existing Typst entrypoint

- Entrypoint: `src/main.typ`.
- Known compile commands:
  - From `report/src`: `typst compile main.typ report.pdf`.
  - From `report`: `typst compile src/main.typ ./build/DA1_23520161_TranNguyenThaiBinh_23521049_NguyenThaiGiaNguyen_SE121.Q21.pdf` via `just build-pdf`.
- `justfile` also defines `build-html`, `build-watch`, `dev`, `format`, `sync-diagrams`, and `sync-gen-mermaid`.

## 2. Template/config files

- `src/main.typ`: main document entrypoint; configures document metadata, page setup, font, table style, paragraph style, heading behavior, figure numbering, outlines, chapter includes, bibliography, and appendix include.
- `src/lib/metadata.typ`: single source of truth for title, authors, keywords, university/school/faculty, supervisor, students, and location.
- `src/coverpage.typ`: cover page macro (`coverpage`) using metadata and `assets/images/uit-logo.jpg`; called directly at the end of the file.
- `src/thanks.typ`: acknowledgement page; currently TaskPilot acknowledgement content and student names from `project-metadata.students`.
- `src/glossaries.typ`: abbreviation/glossary table.
- `src/summary.typ`: abstract/summary page and `theory_reference` helper for links to chapter headings.
- `src/lib/ui.typ`: UI screenshot/table helpers: `ui-figure`, `column`, `ui-table`, `ui-table-figure`.
- `src/lib/usecase.typ`: use case table helpers: `usecase`, `usecase-figure`.
- `src/lib/database.typ`: database table helpers: `column`, `db-table`.
- `src/lib/appendix.typ`: appendix numbering and figure/equation numbering helper: `appendix`.
- `src/ref.bib`: BibTeX bibliography database.
- `requirements.typ`: package imports for `codly` and `codly-languages`; `mmdr` import is commented.
- `README.md`: original template README still references Notopia.
- `AGENTS.md`, `CLAUDE.md`, `.agents/`, `.opencode/`: agent/tooling notes, not Typst template logic.

## 3. Current frontmatter structure

- Existing frontmatter files:
  - `src/coverpage.typ`
  - `src/thanks.typ`
  - `src/glossaries.typ`
  - `src/summary.typ`
  - outlines are generated in `src/main.typ`
- Current order in `src/main.typ`:
  1. Cover page (`#include "./coverpage.typ"`)
  2. Acknowledgement (`#include "./thanks.typ"`)
  3. Generated table of contents (`outline(...)`, unnamed title by default)
  4. Generated list of figures titled `Danh mục hình ảnh`
  5. Generated list of tables titled `Danh mục bảng biểu`
  6. Generated list of raw/code figures titled `Danh mục bảng chương trình`
  7. Generated appendix outline titled `Phụ lục`
  8. `codly` setup
  9. Glossary/abbreviations (`#include "./glossaries.typ"`)
  10. Summary/abstract (`#include "summary.typ"`)
  11. Page numbering reset and main chapters
- Notes for later:
  - If the final university format requires glossary and abstract before the TOC, `src/main.typ` ordering will need a careful later patch.
  - Current generated outline titles are template names, not final Vietnamese university labels.
  - Do not change page/font/heading/caption config during content assembly unless explicitly requested.

## 4. Current chapter structure

- Existing Typst chapters currently included by `src/main.typ`:
  - `src/chapter1/index.typ`: Chapter 1, current template content for Notopia/personal knowledge notes.
  - `src/chapter2/index.typ`: Chapter 2 wrapper, includes many Typst topic files (`go.typ`, `typescript.typ`, `frontend.typ`, `styling.typ`, `nestjs.typ`, `postgres.typ`, `database.typ`, `collorative-solution.typ`, `yjs.typ`, `prosemirror.typ`, `tiptap.typ`, `hocuspocus.typ`, `blocknote.typ`, `openapi.typ`, `grpc.typ`, `traefik.typ`, `casbin.typ`, `meilisearch.typ`, `authentik.typ`, `rustfs.typ`, `observability.typ`, `redpanda.typ`, `watermill.typ`, `nx.typ`).
  - `src/chapter3/index.typ`: Chapter 3 wrapper, includes `survey.typ`, `dev-process.typ`, `architecture.typ`, `usecase.typ`, `class.typ`, `database.typ`, `blocknote.typ`, `casbin.typ`, `health.typ`.
  - `src/chapter4/index.typ`: Chapter 4, UI implementation section using `ui-figure` and `ui-table-figure`; current template content is Notopia UI.
  - `src/chapter5/index.typ`: Chapter 5, conclusion/current template content.
- Existing appendix files:
  - `src/appendix/index.typ`: wraps appendix content with `appendix[...]`.
  - `src/appendix/blocknote.typ`, `src/appendix/casbin.typ`, `src/appendix/healthcheck.typ`, `src/appendix/sqlc.typ`.
- Available Markdown/raw drafts likely intended for TaskPilot assembly:
  - `_incoming/CHAPTER_1_FINAL.md`: likely target Chapter 1.
  - `_incoming/CHAPTER_2_FINAL.md`: likely target Chapter 2.
  - `_incoming/CHAPTER_3_1_FINAL.md`, `_incoming/CHAPTER_3_2_FINAL.md`, `_incoming/CHAPTER_3_3_FINAL.md`, `_incoming/CHAPTER_3_4_3_5_FINAL.md`, `_incoming/CHAPTER_3_6_3_7_FINAL.md`, `_incoming/CHAPTER_3_8_FINAL.md`, `_incoming/CHAPTER_3_9_3_10_FINAL.md`, `_incoming/CHAPTER_3_11_FINAL.md`, `_incoming/CHAPTER_3_12_FINAL.md`, `_incoming/CHAPTER_3_13_FINAL.md`: likely target Chapter 3 sections.
  - `_incoming/CHAPTER_4_FINAL.md`: likely target Chapter 4.
  - `_incoming/CHAPTER_5_1_5_2_FINAL.md`, `_incoming/CHAPTER_5_3_5_4_FINAL.md`: likely target Chapter 5 sections.
  - `_incoming/usecase_mermaid_system_overview.md`, `_incoming/usecase_mermaid_pm_view.md`, `_incoming/usecase_mermaid_member_view.md`, `_incoming/usecase_mermaid_admin_view.md`: use case Mermaid source/reference drafts.
  - `_incoming/PLACEHOLDER_ASSET_STATUS.md`: image placeholder and asset availability tracker.
  - `notes/REPORT_NOTES.md`: broad report notes.
  - `notes/AI_ARCHITECTURE_NOTES.md`: AI architecture notes.
  - `notes/DB_SCHEMA_NOTES.md`: database schema notes.
  - `notes/FRONTEND_WIKI_NOTES.md`: frontend/UI notes and screenshot placeholder notes.
  - `notes/USE_CASE_NOTES.MD`, `notes/USE_CASE_DIAGRAM_MAP.md`, `notes/USE_CASE_DIAGRAM_MAP_PATCH.md`, `notes/USE_CASE_FLOW_AUDIT_AND_PATCH.md`: use case specs, diagram mapping, and audit/patch notes.
  - `docs/ai/numbering-appendix.md`: Typst appendix numbering reference.

## 5. Asset structure

- Existing template/runtime assets under `src/assets`:
  - `src/assets/fonts`: SVN Times New Roman font files.
  - `src/assets/images`: template logos and screenshots, including `uit-logo.jpg`, technology logos, `notopia-nx-graph.png`, `scalar-api-preview.png`, `grafana-observation-log.png`.
  - `src/assets/diagrams`: old sequence diagram `.mmd`, `.hash`, and `.svg` files for note/document use cases.
  - `src/assets/sync-diagrams`: old architecture/class/database SVG diagrams for Notopia.
  - `src/assets/ui`: old current UI screenshot set.
  - `src/assets/old-ui`: older UI screenshot set.
  - `src/assets/spell`: Vietnamese spell additions.
- Incoming TaskPilot assets under `_incoming/asset`:
  - `_incoming/asset/assets/images/logos`: TaskPilot stack logos including Java, Spring Boot, PostgreSQL, Redis, React, TypeScript, Vite, Tailwind, Gemini, OpenAI, OneSignal, Brevo, Docker, GitHub Actions, Vercel, Netlify, Hugging Face, and related logos.
  - `_incoming/asset/chapter2/ch2_14_frontend_supporting_libs.svg`: Chapter 2 frontend supporting libraries figure.
  - `_incoming/asset/assets/diagrams`: `taskpilot_ui_navigation_flow.svg/.mmd` and AHP weight charts (`ch3_12_ahp_weights_balanced.svg`, `urgent.svg`, `training.svg`).
  - `_incoming/asset/assets/sync-diagrams/use-case/use-case-system.svg`: system use case diagram.
  - `_incoming/asset/assets/sync-diagrams/database/taskpilot_erd.svg`: TaskPilot ERD.
  - `_incoming/asset/assets/sync-diagrams/activity/activity-project-access-permission-check.svg`: project access permission activity diagram.
  - `_incoming/asset/assets/sync-diagrams/sequence`: many TaskPilot sequence diagrams for auth, project, member, sprint, task, notification, AI, admin, SSE, and contract flows.
  - `_incoming/asset/assets/ui`: full Chapter 4 screenshot set (`ch4_02_login.png` through `ch4_24_project_settings_members.png`, with some numbering gaps).
  - `_incoming/asset/chapter4/cropped`: cropped versions of the same Chapter 4 screenshots; prefer these later where layout needs tighter images.
- `_incoming/asset/assets/manifest.md` says the incoming collection was pruned to placeholder-required sync diagrams, with counts: UI 22, logos 17, diagrams SVG 3, sequence 35, activity 1, use-case 1, database 1.
- Missing expected images are tracked in `_incoming/PLACEHOLDER_ASSET_STATUS.md`; obvious missing groups include several Chapter 2 concept diagrams and multiple Chapter 3 architecture/deployment/realtime/AI diagrams.

## 6. Important Typst conventions in this repo

- Include chapters by adding `include "./chapterN/index.typ"` inside the chapter block in `src/main.typ`.
- Chapter headings use Typst markup (`=`, `==`, `===`) and are numbered inside the `#{ ... }` block in `src/main.typ` with:
  - `set heading(numbering: "1.")`
  - `set heading(supplement: [Chương])`
  - custom level-1 show rule rendering `Chương <number>` and `upper(it.body)`.
- Global figure numbering is set in `src/main.typ` as:
  - `#set figure(numbering: (..num) => numbering("1.1", counter(heading).get().first(), num.pos().first()))`
  - This intends chapter-based numbering but should be verified during assembly.
- Figure captions are emphasized and gray via `#show figure.caption: emph` and `#show figure.caption: set text(gray.darken(50%), size: 11pt)`.
- Table figures use the same `figure(...)` mechanism with `kind: table`; table captions are moved to top via `#show figure.where(kind: table): set figure.caption(position: top)`.
- Use `#figure(image(...), caption: [...])` for general figures.
- Use `#ui-figure(path, [caption], height: ...)` for UI screenshots in Chapter 4.
- Use `#ui-table(...)` and `#ui-table-figure(...)` for UI component tables.
- Use `#usecase(...)` and `#usecase-figure(...)` for use case specs.
- Use `#db-table(...)` inside `#figure(..., caption: [...])` for database schema tables.
- References use `#bibliography("./ref.bib", title: "Tài liệu tham khảo", style: "ieee")`.
- Code/raw formatting is initialized with `codly` in `src/main.typ`.
- The current outlines are generated with `outline(...)` targeting headings, figures, table figures, raw/code figures, and appendix headings.

## 7. Risks before assembly

- Existing Typst chapters are still mostly the old Notopia/template report; TaskPilot chapter drafts are in `_incoming` Markdown files and are not yet converted.
- Frontmatter ordering currently places TOC/list of figures/list of tables before glossary and abstract; later formatting requirements may require a careful `src/main.typ` reorder.
- Many incoming drafts reference placeholder images; `_incoming/PLACEHOLDER_ASSET_STATUS.md` shows several missing Chapter 2 and Chapter 3 diagrams.
- Incoming Markdown tables and use case tables are likely wide and may overflow A4 margins when converted directly to Typst tables.
- Figure/table numbering and captions should be checked after conversion; current numbering uses `counter(heading).get().first()` and may behave unexpectedly around unnumbered frontmatter/appendix.
- Compile currently succeeds, but Typst warns that `SVN-Times New Roman 2` is an unknown font family in the current command environment.
- Asset paths in `_incoming` will need to be copied or referenced consistently from `src` before inclusion.
- README and existing output names still reference Notopia/old student IDs.

## 8. Recommended next steps

1. Freeze `src/main.typ` and other template/config files unless a frontmatter-order change is explicitly approved.
2. Map each `_incoming/CHAPTER_*_FINAL.md` file to the target `src/chapterN` Typst file or section file.
3. Convert one chapter at a time from Markdown to Typst, preserving technical meaning and existing template conventions.
4. Copy or reference only confirmed TaskPilot assets from `_incoming/asset` into a stable `src/assets/taskpilot` structure.
5. Replace figure placeholders with Typst figures using existing helper conventions and record any missing asset as a TODO near the figure.
6. Convert wide Markdown tables cautiously, using Typst table helpers or page/scale strategies only after checking output.
7. Compile after each chapter insertion and fix only local syntax/path issues.
8. After all chapters compile, review frontmatter order, figure/table lists, references, page numbering, and final PDF layout.
