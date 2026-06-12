// Use case specification library
// Define use cases as data, render as tables

#import "report-style.typ": table_body_size, table_compact_size

/// Renders a use case specification table with flexible field parameters
///
/// Supported fields:
/// - id: string (Use Case ID)
/// - name: string (Use Case Name)
/// - description: string (Description)
/// - actors: string (Actor(s))
/// - priority: string (Priority level)
/// - trigger: string (What triggers this use case)
/// - preconditions: content (Pre-condition(s))
/// - postconditions: content (Post-condition(s))
/// - basicFlow: content (Basic Flow steps)
/// - alternateFlow: content (Alternate Flow steps)
/// - exceptionFlow: content (Exception Flow steps)
/// - businessRules: string (Business Rules)
/// - nfRequirements: string (Non-Functional Requirements)
///
/// - style: optional styling configuration (columnWidths, etc.)
///
/// Example:
/// ```
/// #usecase(
///   id: "UC01",
///   name: "Create Note",
///   description: "User creates a new note",
///   actors: "User",
///   basicFlow: [...],
/// )
/// ```
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
  compact: false,
) = {
  let fields = (
    "ID": id,
    "Name": name,
    "Description": description,
    "Actor(s)": actors,
    "Priority": priority,
    "Trigger": trigger,
    "Pre-condition(s)": pre-conditions,
    "Post-condition(s)": post-conditions,
    "Basic Flow": basic-flow,
    "Alternate Flow": alternate-flow,
    "Exception Flow": exception-flow,
    "Business Rules": business-rules,
    "Non-Functional Requirements": nf-requirements,
  )

  let cells = fields
    .pairs()
    .filter(pair => pair.at(1) != none)
    .map(pair => ([*#pair.at(0)*], pair.at(1)))
    .flatten()

  show table: set par(justify: false)

  {
    set text(size: if compact { table_compact_size } else { table_body_size })
    table(
      columns: column-widths,
      align: left,
      stroke: 0.5pt,
      table.header([*Trường*], [*Nội dung*]),
      ..cells
    )
  }
}

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
