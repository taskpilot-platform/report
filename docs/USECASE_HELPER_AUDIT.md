# USECASE_HELPER_AUDIT.md

## Current `usecase` signature

```typst
#let usecase(
  id: none,
  name: none,
  description: none,
  actors: none,
  priority: none,
  trigger: none,
  pre-conditions: none,
  post-conditions: none,
  basic-flow: none,
  alternate-flow: none,
  exception-flow: none,
  business-rules: none,
  nf-requirements: none,
  column-widths: (9em, 1fr),
) = { ... }
```

`usecase(...)` renders a two-column `table(...)` with header cells `Trường` and `Nội dung`.

## Current `usecase-figure` signature

```typst
#let usecase-figure(
  usecase-data,
  breakable: true,
  caption: none,
) = { ... }
```

Current implementation:

```typst
#let usecase-figure(
  usecase-data,
  breakable: true,
  caption: none,
) = {
  show figure: set block(breakable: breakable)

  figure(
    caption: caption,
    usecase-data,
  )
}
```

## Template table handling

- `src/main.typ` generates the list of tables with:

```typst
outline(
  title: "Danh mục bảng biểu",
  target: figure.where(kind: table).before(...),
)
```

- `src/main.typ` places table figure captions above tables with:

```typst
#show figure.where(kind: table): set figure.caption(position: top)
```

- Normal non-table figures are not included in `Danh mục bảng biểu`; the outline target is specifically `figure.where(kind: table)`.

## Existing use case usage

Old template content in `src/chapter3/usecase.typ` uses:

```typst
#usecase-figure(
  usecase(...),
  caption: [Mô tả use case ...],
)
```

The old use cases were implemented with `usecase-figure(...)`. The helper wraps the generated table in `figure(...)`, but it does not explicitly set `kind: table`.

## Audit result

- `usecase-figure` currently wraps content in `figure(...)`: yes.
- `usecase-figure` currently supports `breakable: true`: yes.
- `usecase-figure` currently sets `kind: table`: no, not explicitly.
- Captions are passed to `figure(...)`; table-caption positioning depends on whether the figure is recognized as `kind: table`.
- Under Typst's automatic figure kind inference, a `figure(...)` whose body is a table may be treated as a table figure. However, the helper does not make this behavior explicit or guaranteed.

## Recommendation

- `SAFE_TO_PATCH: yes`
- `RECOMMENDED_PATCH: change usecase-figure to call figure(usecase-data, caption: caption, kind: table)`
- `REASON: src/main.typ lists only figure.where(kind: table), and explicitly setting kind: table makes use case specification tables reliably appear in Danh mục bảng biểu and receive top-positioned table captions.`

Recommended exact patch:

```typst
#let usecase-figure(
  usecase-data,
  breakable: true,
  caption: none,
) = {
  show figure: set block(breakable: breakable)

  figure(
    usecase-data,
    caption: caption,
    kind: table,
  )
}
```

Risk of patching:

- Low risk if `usecase-figure(...)` is used only for `usecase(...)` tables, which is its intended purpose.
- If someone passes non-table content into `usecase-figure(...)`, it would still be listed as a table. Current repo usages pass `usecase(...)`.
- Long use case tables may still need layout review after content conversion, but the helper already exposes `breakable: true`.

## Compile status

- Command run from `report/src`: `typst compile main.typ report.pdf`
- Compile status: success.
- Compile output: no warnings or errors.
