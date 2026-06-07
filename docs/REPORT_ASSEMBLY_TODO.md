# REPORT_ASSEMBLY_TODO.md

## Compile check

- [x] Detected Typst entrypoint: `src/main.typ`.
- [x] Ran compile check from `report/src`: `typst compile main.typ report.pdf`.
- [x] Compile status: success.
- [x] Ran compile check after Chapter 1 conversion: success.
- [x] Ran compile check after Chapter 5 conversion: success.
- [x] Ran compile check after Chapter 4 conversion: success.
- [x] Ran compile check after replacing Chapter 4 navigation SVG with PNG and adding bordered UI figures: success.
- [x] Ran compile check after Chapter 2 conversion: success.
- [ ] Resolve warning if required later:

```text
warning: unknown font family: svn-times new roman 2
   ┌─ \\?\D:\HK6-UIT\DA1\report\src\main.typ:20:8
   │
20 │   font: "SVN-Times New Roman 2",
   │         ^^^^^^^^^^^^^^^^^^^^^^^
```

- [x] Resolved Chapter 4 navigation diagram warning by using `taskpilot_ui_navigation_flow.png` instead of the SVG with `foreignObject`.
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
- [x] Convert/insert Chapter 4 from `_incoming/CHAPTER_4_FINAL.md`.
- [x] Convert/insert Chapter 5 from `_incoming/CHAPTER_5_1_5_2_FINAL.md` and `_incoming/CHAPTER_5_3_5_4_FINAL.md`.
- [ ] Fix image paths after deciding final asset destination under `src/assets`.
- [ ] Fix figure/table captions using existing Typst figure conventions.
- [ ] Compile PDF after each major chapter insertion.
- [ ] Review TODOs and missing assets from `_incoming/PLACEHOLDER_ASSET_STATUS.md`.
- [ ] Review final page layout for wide tables, oversized diagrams, and screenshot scaling.
- [ ] Review bibliography/reference citations after content insertion.

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
- Compile succeeded after switching the navigation diagram to PNG.

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

## Notes for next assembly run

- Do not rewrite chapter content during conversion; preserve technical meaning.
- Keep template/page/font/heading config unchanged unless the user explicitly asks for a formatting patch.
- Prefer cropped Chapter 4 screenshots from `_incoming/asset/chapter4/cropped` if the full screenshots are too large.
- Record missing images near their future Typst figure locations instead of deleting placeholders.
