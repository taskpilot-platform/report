# FINAL_AUDIT_REPORT.md

## 1. Audit Scope And Status

- Scope checked: citations/references, list of figures, list of tables, glossary/abbreviations, chapter opening paragraphs, and formatting consistency.
- Source modification policy: no report source files were modified during this audit.
- Durable output created by this audit: `docs/FINAL_AUDIT_REPORT.md`.
- Compile check: `typst compile main.typ report.pdf` from `report/src` completed successfully with no warnings printed by Typst.
- Figure query check: `typst query main.typ "figure.where(kind: image)" --field caption --format json` returned 112 image figures.
- Table query check: `typst query main.typ "figure.where(kind: table)" --field caption --format json` returned 81 table figures.
- Visual PDF render check: not completed because `pdftoppm`, `pdfinfo`, `pypdf`, `pdfplumber`, and `PyMuPDF` are not available in this environment. Formatting findings below are based on Typst compile/query results and source inspection.

## 2. Citations And References

### 2.1 Citation Usage In Active Sources

Active TaskPilot chapters currently use plain numeric citation text such as `[1]`, `[2]`, `[13][14][15]`, not Typst bibliography keys.

Numeric citation usages found in active compiled sources:

- `src/chapter2/sections/2_1_project_management.typ`: `[1]`, `[2]`, `[3]`
- `src/chapter2/sections/2_3_assignment_algorithm.typ`: `[4]`
- `src/chapter2/sections/2_5_backend.typ`: `[5]`, `[6]`
- `src/chapter2/sections/2_6_frontend.typ`: `[7]`, `[8]`, `[9]`
- `src/chapter2/sections/2_7_storage.typ`: `[10]`, `[11]`
- `src/chapter2/sections/2_8_ai_provider.typ`: `[12]`, `[13]`, `[14]`, `[15]`
- `src/chapter2/sections/2_9_realtime_notification.typ`: `[16]`, `[17]`, `[18]`
- `src/chapter2/sections/2_10_deployment.typ`: `[19]`, `[20]`, `[21]`, `[22]`
- `src/chapter3/sections/3_1_overview.typ`: `[24]`, `[25]`, `[26]`
- `src/chapter3/sections/3_3_usecase.typ`: `[7]`, `[8]`, `[9]`, `[11]`, `[13]`, `[14]`, `[15]`, `[16]`, `[17]`, `[18]`, `[20]`, `[21]`, `[22]`, `[23]`

Notes:

- Citation `[23]` is used in active Chapter 3 but no matching reference entry was found in the incoming temporary reference blocks scanned during this audit.
- Citation `[24]`, `[25]`, `[26]` appear in Chapter 3 and have temporary reference notes in `_incoming/CHAPTER_3_1_FINAL.md`, but those references have not been moved into the final bibliography.
- The active compiled sources contain Typst cross-reference labels in `src/summary.typ`, such as `@introduction`, `@theory-basis`, `@architecture`, `@implementation`, and `@conclusion`. These are internal document references, not bibliography citations.
- A literal escaped mention `\@Admin` appears in `src/chapter4/index.typ`; this is UI content, not a citation.

### 2.2 Bibliography Entries

Current bibliography file:

- `src/ref.bib`

`src/ref.bib` contains 67 BibTeX entries from the old sample/template project, including entries for BlockNote, Yjs, Casbin, Authentik, Grafana, Traefik, Redpanda, SQLC, Watermill, gRPC, and related technologies.

Under the active TaskPilot source files checked in this audit:

- No `@bib-key` citation usage maps to `src/ref.bib`.
- All 67 `src/ref.bib` entries are effectively unused by the current compiled TaskPilot chapters.
- The numeric citations `[1]` to `[26]` are not connected to `src/ref.bib`.

Recommended cleanup:

- Convert final numeric references into proper `ref.bib` entries or intentionally keep a manually numbered reference section, but use one approach consistently.
- Move the temporary references from `_incoming/CHAPTER_2_FINAL.md` and `_incoming/CHAPTER_3_1_FINAL.md` into the final reference system.
- Add or reconcile the missing `[23]` reference before final submission.
- Remove or archive old template bibliography entries that are no longer cited by the TaskPilot report.

## 3. List Of Figures Audit

The main template generates the list of figures with:

- `outline(target: figure.where(kind: image)...)`

The query against compiled `main.typ` returned 112 `figure.where(kind: image)` captions. This means the current Typst figure objects are visible to the list-of-figures mechanism.

Findings:

- Chapter 2 technology/logos/diagrams are wrapped as Typst figures.
- Chapter 3 diagrams are wrapped as Typst figures.
- Chapter 4 UI screenshots use `ui-figure(...)`, which wraps images in Typst `figure(...)`.
- Chapter 4 image borders are applied through `src/lib/ui.typ` via `bordered-image(...)`; cover/logo images are not affected by this helper.
- No active-source `caption: none` image figure issue was found.

Risk:

- A full rendered-page visual scan could not be performed in this environment, so this audit did not visually verify whether every SVG/PNG is non-blank, sharp, and unclipped.

## 4. List Of Tables Audit

The main template generates the list of tables with:

- `outline(target: figure.where(kind: table)...)`

The query against compiled `main.typ` returned 81 `figure.where(kind: table)` captions. This confirms current table figures are visible to the list-of-tables mechanism.

Findings:

- `src/lib/ui.typ` defines `ui-table-figure(...)`, and active Chapter 3/4 tables use it in many places.
- `src/lib/usecase.typ` defines `usecase-figure(...)`; because the body is a Typst `table(...)`, compiled use case specifications are detected as `kind: table`.
- Use case tables in Chapter 3 should appear in `Danh mục bảng biểu` under current helper behavior.
- Only one direct `#table(...)` occurrence was found in active Chapter 3 section sources: it is nested inside `#ui-table-figure(...)` in `src/chapter3/sections/3_12_assignment_algorithm.typ`, so it still appears as a table figure.

Risks:

- `src/lib/ui.typ` and `src/lib/usecase.typ` set `show figure: set block(breakable: true)` locally inside helpers. Compile succeeds, but long-table pagination should still be visually reviewed in the final PDF.
- `src/chapter3/sections/3_12_assignment_algorithm.typ` wraps one table in `text(size: 8.5pt)`, which conflicts with the current project rule to avoid shrinking table font size.
- `src/chapter4/index.typ` defines component tables with `set text(size: 10pt)`. This may be intentional for UI component tables, but it is not consistent with the global 13pt body/table font rule.

## 5. Chapter Opening Paragraph Audit

Reference style:

- Chapter 1 has an italic opening paragraph immediately under the chapter title:
  `src/chapter1/index.typ`, lines 3-9 use `#emph[...]`.

Chapter status:

- Chapter 1: has italic intro paragraph.
- Chapter 2: has an opening paragraph under the title, but it is not italic.
- Chapter 3: no chapter-level opening paragraph; it immediately includes section files after the chapter heading.
- Chapter 4: no chapter-level italic opening paragraph; it begins with helper definitions, then the chapter title, then section 4.1.
- Chapter 5: no chapter-level italic opening paragraph; it begins directly with section 5.1.

Recommended cleanup:

- Add or convert chapter intro paragraphs for Chapters 2, 3, 4, and 5 to match the Chapter 1 `#emph[...]` style.
- Keep this as a formatting/content assembly pass, not a template change.

## 6. Glossary And Abbreviations Audit

Current glossary file:

- `src/glossaries.typ`

Current glossary appears to be inherited from the old sample/template and includes entries such as ABAC, ACL, CDC, CRDT, HTTP/2, ISR, JSX, Nx, OAuth2, OIDC, OTLP, Protobuf, RPC, SEO, SQLC, SSG, SSO, SSR, TOML, TSX, and gRPC.

Frequently used TaskPilot terms missing from the glossary:

- `AI`
- `AHP`
- `CDN`
- `CORS`
- `CRUD`
- `DTO`
- `ERD`
- `FK`
- `HTML`
- `HTTP`
- `JAR`
- `JPA`
- `JSON`
- `JSONB`
- `JWT`
- `LLM`
- `OOO`
- `PK`
- `PM`
- `RAG`
- `RAM`
- `S3`
- `SDK`
- `SMTP`
- `SPA`
- `UI`
- `WIP`

Existing glossary entries that appear obsolete in the active TaskPilot sources:

- `ABAC`
- `ACL`
- `CDC`
- `CLI`
- `CRDT`
- `DX`
- `HTTP/2`
- `ISR`
- `JSX`
- `Nx`
- `OAuth2`
- `OIDC`
- `ORM`
- `OTLP`
- `OpenTelemetry`
- `Protobuf`
- `RBAC`
- `RPC`
- `SEO`
- `SQLC`
- `SSG`
- `SSO`
- `SSR`
- `TOML`
- `TSX`
- `gRPC`

Entries currently present and still relevant:

- `API`
- `CI/CD`
- `CSS`
- `DOM`
- `REST`
- `SQL`
- `SSE`
- `UML`

Recommended cleanup:

- Replace old-template glossary entries with TaskPilot-specific abbreviations.
- Keep database-only abbreviations such as `PK` and `FK` if Chapter 3.8 database tables remain in the main report.

## 7. Formatting Consistency Audit

### 7.1 Table Styling

The global template in `src/main.typ` sets table fill behavior:

- Header row: black fill.
- Odd body rows: light gray.
- Even body rows: white.
- Header text: white.
- Table paragraph justification disabled.

This matches the desired zebra/alternating table style at the template level.

Findings:

- Most Chapter 3 table helpers use normal `table(...)` under `ui-table-figure(...)` or `usecase-figure(...)`, so they inherit the global table styling.
- `src/chapter3/sections/3_12_assignment_algorithm.typ` contains a table wrapped in `text(size: 8.5pt)`, which is the main formatting inconsistency found.
- `src/chapter4/index.typ` component-table helper uses `set text(size: 10pt)`. This is consistent inside Chapter 4 but differs from the global 13pt table-body expectation.

### 7.2 Caption Positions

The template has:

- `#show figure.where(kind: table): set figure.caption(position: top)`
- Image captions use the normal figure caption position below the image.

Findings:

- Table captions should appear above tables.
- Figure captions should appear below figures.
- `typst query` confirms both image and table figure captions exist in the compiled report.

### 7.3 Headings And Orphans

Source inspection did not find obvious TODO placeholders or intentionally missing caption placeholders in active report chapters.

Limitations:

- Orphaned headings and page-bottom collisions require rendered-page visual inspection. This could not be completed because PDF rendering tools are unavailable in the environment.
- A final visual pass should still inspect long Chapter 3 tables, Chapter 3.12 formulas/tables, and dense Chapter 4 component tables.

### 7.4 Chapter Title Capitalization

Current source titles:

- Chapter 1: `Giới thiệu đề tài`
- Chapter 2: `CƠ SỞ LÝ THUYẾT`
- Chapter 3: `PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG`
- Chapter 4: `XÂY DỰNG ỨNG DỤNG`
- Chapter 5: `Kết luận`

The template uppercases level-1 headings in rendering, so visual chapter titles should appear uppercase consistently. Source capitalization is mixed, but rendered output should be normalized by the template.

## 8. Final Risks Before Submission

- References are not final: numeric citation text is not connected to `src/ref.bib`.
- Citation `[23]` is used but no matching temporary reference was found in the scanned incoming reference blocks.
- `src/ref.bib` still contains old sample-project entries and appears unused by active TaskPilot chapters.
- Glossary still contains many old-template terms and is missing several TaskPilot-specific abbreviations.
- Chapters 2, 3, 4, and 5 do not yet match Chapter 1's italic opening paragraph style.
- At least one Chapter 3.12 table uses reduced font size (`8.5pt`), which violates the current formatting rule.
- Chapter 4 component tables use `10pt`, which should be accepted intentionally or normalized in a later formatting pass.
- Full PDF visual review remains necessary for long tables, heading orphans, and image clipping because local PDF render tooling is unavailable.

## 9. Recommended Final Cleanup Order

1. Finalize the reference strategy: either convert `[n]` citations into BibTeX-backed citations or build a manual numbered reference section.
2. Move `_incoming` temporary references into the final reference system and resolve missing `[23]`.
3. Replace old glossary entries with TaskPilot-specific abbreviations.
4. Add italic chapter opening paragraphs for Chapters 2, 3, 4, and 5, matching Chapter 1.
5. Normalize table font-size exceptions, especially the `8.5pt` table in Chapter 3.12.
6. Run `typst compile main.typ report.pdf`.
7. Perform a rendered PDF visual pass for long tables, figure sharpness, heading orphans, margins, and page-footer collisions.
