# Appendix Heading Numbering — Problem Statement

## Current state

Appendix headings are formatted inside `src/lib/appendix.typ` using a custom
numbering lambda passed to `set heading(numbering: ...)`. The relevant levels:

| Level | Numbering returns | Heading displays | Ref (`@label`) renders |
|-------|-------------------|------------------|------------------------|
| 1     | `none`            | `PHỤ LỤC` (show rule, all-caps) | — |
| 2     | `"A"`             | `Phụ lục A. Tiêu đề` (show rule adds the dot manually) | `Phụ lục A` ✓ |
| 3     | `"A.1"`           | `A.1 Tiêu đề` (no dot before title) ✗ | `Phụ lục A.1` ✓ |
| 4+    | `none`            | plain body text | — |

Level 2 is fine because its show rule adds the dot manually and the numbering
function itself returns `"A"` (no trailing dot). Level 3 has no custom show
rule, so it relies entirely on what the numbering function returns — currently
`"A.1"` without trailing dot, which means the heading title is not separated
from the number by a period.

## Why it got here

### The root tension

Typst uses **the same numbering function** for two distinct purposes:

1. **Heading display** — the number prefix rendered before the title in the
   document body and in the outline.
2. **Cross-reference display** — the number rendered when `@label` is used to
   cite the heading from another section.

There is no built-in mechanism to return different strings for these two
contexts from a single numbering function.

### What main chapter headings do

Main content headings use `set heading(numbering: "1.")`. The pattern `"1."`
has **one** number placeholder and a trailing `.` literal. When Typst calls
this for a level-2 heading it passes **two** counter values (e.g. `[2, 13]`).
Because there are more values than placeholders, the trailing `.` is consumed
as a separator between the two numbers, and no extra dot is appended:

```
numbering("1.", 2, 13)  →  "2.13."
```

Wait — the heading displays "2.13. Tổng quan…", so the trailing dot IS present.
The heading renderer places that dot before the title. And when the same heading
is referenced with `@label` at the end of a sentence, the ref renders as
"Chương 2.13." — which means sentences ending with `@label.` technically also
produce "Chương 2.13.." in main content, but this has not been noticed or
flagged in practice.

### What appendix headings do

The appendix uses a custom lambda. For level 3 it explicitly calls:

```typst
numbering("A.1.", n.at(1), n.at(2))
```

The pattern `"A.1."` has **two** placeholders and a trailing `.` literal. With
exactly two numbers provided, both placeholders are filled and the trailing `.`
remains as a literal suffix:

```
numbering("A.1.", 1, 2)  →  "A.2."
```

This trailing dot is what caused `@appendix-casbin-example` at the end of a
sentence to render as `"Phụ lục B.1.."` — two periods.

### The attempted fix

To eliminate the double period, the trailing dot was removed from the pattern:

```typst
numbering("A.1", n.at(1), n.at(2))  →  "A.2"
```

This fixed the ref rendering (`"Phụ lục B.1"` — one period at sentence end),
but also removed the dot from the **heading display**, which now renders as
`"A.1 Tiêu đề"` instead of `"A.1. Tiêu đề"`, inconsistent with main chapter
headings.

## The three options

### Option A — Restore `"A.1."` (heading display wins, refs get double dot)

Revert the level-3 numbering pattern back to `"A.1."`. Heading display becomes
`"A.1. Tiêu đề"` again, consistent with main chapters. Refs at end of sentence
produce `"Phụ lục B.1.."` — same latent problem that main chapter refs have
but nobody has complained about yet.

**Pros:** heading looks correct, no code patches needed.  
**Cons:** double period in refs at sentence end (same as main chapter refs).

### Option B — Keep `"A.1"` (refs win, heading loses dot)

Leave the current state. Refs are clean (`"Phụ lục B.1"`), but heading display
is `"A.1 Tiêu đề"` without a separator dot — visually inconsistent with main
chapters.

**Pros:** refs are clean, no code patches needed.  
**Cons:** heading display is inconsistent with main chapter style.

### Option C — Restore `"A.1."` + `show ref` patch (both look right, requires patch)

Keep `"A.1."` for correct heading display, and add a global `show ref` rule in
`src/main.typ` that intercepts references to appendix headings, detects them by
comparing their page/position against the `<end-content>` metadata marker, and
reconstructs the reference number without the trailing dot.

This was implemented and removed earlier. The secondary issue it caused (refs
rendered as blue links because `show ref` uses `link()` internally and a global
`show link: set text(fill: blue)` coloured all links) can be fixed independently
by making `show link` URL-aware: only apply blue to links whose destination is a
string (external URL), not a location (internal cross-reference).

**Pros:** heading display correct, ref display correct.  
**Cons:** two interconnected show-rule patches that future contributors need to
understand and maintain together.
