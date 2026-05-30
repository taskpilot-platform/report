#let ui-figure(
  image-src,
  caption,
) = figure(
  image(image-src),
  caption: caption,
)

/// - name: string (Column name)
/// - type: string (Data type)
/// - description: string (Column description)
#let column(name, type, description) = {
  (name: name, type: type, description: description)
}

/// - columns: variadic column definitions (created with column() function)
///
/// Example:
/// ```
/// #figure(
///   ui-table(
///     column("Button", "Button", "Clickable element"),
///   ),
///   caption: [UI component table],
/// )
/// ```
#let ui-table(
  ..cols,
) = {
  let columns = cols.pos()

  table(
    columns: (auto, auto, auto, auto),
    align: (center, left, left, left),
    stroke: 0.5pt,

    table.header([*STT*], [*Tên*], [*Loại*], [*Mô tả*]),

    ..columns
      .enumerate()
      .map(((i, col)) => (
        [#(i + 1)],
        [#col.name],
        [#col.type],
        [#col.description],
      ))
      .flatten(),
  )
}

#let ui-table-figure(
  table-data,
  breakable: true,
  caption: none,
) = {
  show figure: set block(breakable: breakable)

  figure(
    table-data,
    caption: caption,
  )
}
