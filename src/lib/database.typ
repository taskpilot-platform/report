#import "ui.typ": ui-table-figure
#import "report-style.typ": table_body_size, table_raw_size

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
  col-widths: (0.3fr, 1fr, 1.1fr, 2.15fr, 2.05fr),
  inset: 0.34em,
  text-size: table_body_size,
  raw-size: table_raw_size,
) = {
  let data-columns = cols.pos()

  {
    set text(size: text-size)
    show raw: it => {
      set text(size: raw-size)
      show regex("[._/,\-()':=]"): char => char + sym.zws
      it
    }
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
  col-widths: (0.3fr, 1fr, 1.1fr, 2.15fr, 2.05fr),
  inset: 0.34em,
  text-size: table_body_size,
  raw-size: table_raw_size,
  ..cols,
) = ui-table-figure(
  db-table(
    ..cols,
    col-widths: col-widths,
    inset: inset,
    text-size: text-size,
    raw-size: raw-size,
  ),
  breakable: breakable,
  caption: caption,
  placement: placement,
)
