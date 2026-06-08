#import "ui.typ": ui-table-figure

/// Creates a type-safe column definition with runtime validation
///
/// - name: string (Column name)
/// - type: string (Data type)
/// - constraint: string (Column constraints like PK, FK, NOT NULL)
/// - description: string (Column description)
#let column(name, type, constraint, description) = {
  (name: name, type: type, constraint: constraint, description: description)
}

/// - columns: variadic column definitions (created with column() function)
#let db-table(
  ..cols,
) = {
  let columns = cols.pos()

  table(
    columns: (0.4fr, 1fr, 1.5fr, 1.2fr, 2.3fr),
    align: (center, left, left, left, left),
    stroke: 0.5pt,

    table.header(
      [*STT*], [*Thuộc tính*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Diễn giải*]
    ),

    ..columns
      .enumerate()
      .map(((i, col)) => (
        [#(i + 1)],
        [#col.name],
        [#col.type],
        [#col.constraint],
        [#col.description],
      ))
      .flatten(),
  )
}

#let db-table-figure(
  caption: none,
  ..cols,
) = ui-table-figure(
  db-table(..cols),
  caption: caption,
)
