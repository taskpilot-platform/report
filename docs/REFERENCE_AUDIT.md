# REFERENCE AUDIT

## Resolution of citation [23]
Citation [23] was found in `src/chapter3/sections/3_3_usecase.typ` grouped as `[20][21][22][23]` referring to Netlify, Vercel, and Hugging Face Space.

In the previous draft `_incoming/CHAPTER_2_FINAL.md`, the citations were numbered incorrectly (duplicates on [22]). The intended numbering based on the context in Chapter 2 (2.10 Deployment) and Chapter 3 (3.3 Usecase) is:
- [20] GitHub Actions
- [21] Vercel
- [22] Netlify
- [23] Hugging Face Space

This numbering perfectly matches the sequence of sections in 2.10 and the citations used. Therefore, [23] was successfully resolved to Hugging Face Space.

## Remaining temporary reference blocks
Searched the `src/` directory for any remaining "Tài liệu tham khảo" or temporary reference blocks at the bottom of sections. None were found in the active source files. The reference blocks were correctly kept in the `_incoming/` drafts and have not been mistakenly copy-pasted into the `.typ` sources.

## Final Manual Reference Section
A final manually numbered reference section matching [1]-[26] was created at `src/references.typ` and `#include "./references.typ"` replaced the `#bibliography` block in `src/main.typ`.
The `src/ref.bib` was left untouched in this pass as requested, but is no longer included in the final render.
