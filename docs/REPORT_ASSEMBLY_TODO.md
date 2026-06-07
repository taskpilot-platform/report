# REPORT_ASSEMBLY_TODO.md

## Compile check

- [x] Detected Typst entrypoint: `src/main.typ`.
- [x] Ran compile check from `report/src`: `typst compile main.typ report.pdf`.
- [x] Compile status: success.
- [x] Ran compile check after Chapter 1 conversion: success.
- [x] Ran compile check after Chapter 5 conversion: success.
- [ ] Resolve warning if required later:

```text
warning: unknown font family: svn-times new roman 2
   ┌─ \\?\D:\HK6-UIT\DA1\report\src\main.typ:20:8
   │
20 │   font: "SVN-Times New Roman 2",
   │         ^^^^^^^^^^^^^^^^^^^^^^^
```

## Assembly checklist

- [x] Compile existing template.
- [ ] Add/adjust frontmatter only after confirming whether `src/main.typ` ordering may be changed.
- [x] Convert/insert Chapter 1 from `_incoming/CHAPTER_1_FINAL.md`.
- [ ] Convert/insert Chapter 2 from `_incoming/CHAPTER_2_FINAL.md`.
- [ ] Convert/insert Chapter 3 from `_incoming/CHAPTER_3_*_FINAL.md` files.
- [ ] Convert/insert Chapter 4 from `_incoming/CHAPTER_4_FINAL.md`.
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

## Notes for next assembly run

- Do not rewrite chapter content during conversion; preserve technical meaning.
- Keep template/page/font/heading config unchanged unless the user explicitly asks for a formatting patch.
- Prefer cropped Chapter 4 screenshots from `_incoming/asset/chapter4/cropped` if the full screenshots are too large.
- Record missing images near their future Typst figure locations instead of deleting placeholders.
