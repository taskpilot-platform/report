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
  col-widths: (0.3fr, 1fr, 1.1fr, 1.7fr, 2.3fr),
  inset: 0.24em,
) = {
  let data-columns = cols.pos()

  {
    set text(size: 8pt)
    table(
      columns: col-widths,
      align: (center + top, left + top, left + top, left + top, left + top),
      inset: inset,
      stroke: 0.5pt,

      table.header(
        [*STT*], [*Thuộc tính*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Diễn giải*]
      ),

      ..data-columns
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
}

#let db-table-figure(
  caption: none,
  breakable: true,
  placement: none,
  ..cols,
) = ui-table-figure(
  db-table(..cols),
  breakable: breakable,
  caption: caption,
  placement: placement,
)
