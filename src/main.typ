#import "./lib/metadata.typ": project-metadata

#set document(
  title: project-metadata.title,
  author: project-metadata.authors,
  keywords: project-metadata.keywords,
)

#set page(
  paper: "a4",
  margin: (
    left: 2cm,
    right: 2cm,
    top: 2cm,
    bottom: 2cm,
  ),
)

#set text(
  font: "SVN-Times New Roman 2",
  size: 13pt,
  lang: "vi",
)

#set table(
  inset: 0.5em,
  fill: (x, y) => {
    if y == 0 {
      black
    } else if calc.odd(y) {
      gray.lighten(90%)
    } else {
      white
    }
  },
)
#show table.cell.where(y: 0): set text(white)
#show table: set par(justify: false)

#set par(
  justify: true,
  leading: 1em,
  spacing: 1em,
  first-line-indent: (
    amount: 1em,
    all: false,
  ),
)

#show link: set text(fill: blue.darken(30%))

#show raw: set text(size: 9pt)

#set heading(numbering: (..nums) => {
  let levels = nums.pos()
  if levels.len() == 1 {
    [Chương #levels.first(). ]
  } else {
    numbering("1.1.", ..nums)
  }
})

#show heading.where(level: 1): set heading(supplement: none)

#show heading.where(level: 1): it => context {
  pagebreak()
  if it.numbering != none {
    let nums = counter(heading).get()
    align(center, [
      #counter(heading).display(it.numbering) #upper(it.body)
    ])
  } else {
    align(center, upper(it.body))
  }
}

#show heading: it => context {
  if it.level <= 3 {
    it
  } else {
    it.body
  }
}

#show ref: it => {
  let el = it.element
  if el != none and el.func() == heading and el.level == 1 {
    strong(link(el.location(), [#el.supplement #numbering(
        el.numbering,
        ..counter(heading).at(el.location()),
      ) #el.body]))
  } else {
    it
  }
}

#set figure(
  numbering: (..num) => {
    numbering("1.1", counter(heading).get().first(), num.pos().first())
  },
)
#show figure.caption: emph
#show figure.caption: set text(gray.darken(50%), size: 11pt)
#show figure.where(kind: table): set figure.caption(position: top)

#include "./coverpage.typ"

#set page(
  numbering: "1",
  footer: context {
    align(center)[
      #box(width: 100%, stroke: (top: 0.5pt), inset: (top: 1em))[
        #counter(page).display()
      ]
    ]
  },
)

#set page(
  margin: (
    top: 3cm,
    bottom: 3.5cm,
    left: 3.5cm,
    right: 2cm,
  ),
)

#include "./thanks.typ"

#[
  #show outline.entry.where(level: 1): set text(weight: "bold")
  #context {
    let loc = query(<appendix-metadata>)
    let target = if loc.len() > 0 {
      selector(heading).before(loc.first().location())
    } else {
      heading
    }

    outline(
      depth: 3,
      indent: 1em,
      target: target,
    )
  }
]

#outline(title: "Danh mục hình ảnh", target: figure.where(kind: image))

#outline(title: "Danh mục bảng biểu", target: figure.where(kind: table))

#outline(title: "Danh mục bảng chương trình", target: figure.where(kind: raw))

#outline(title: "Phụ lục", target: figure.where(kind: raw))

#import "@preview/codly:1.3.0": *
#show: codly-init.with()
#codly(
  zebra-fill: none,
  inset: (top: 0.1em, bottom: 0.1em), // Is it... the right way
)

#counter(page).update(1)

#include "./glossaries.typ"

#include "summary.typ"

#{
  include "./chapter1/index.typ"

  include "./chapter2/index.typ"

  include "./chapter3/index.typ"

  include "./chapter4/index.typ"

  include "./chapter5/index.typ"
}

#bibliography(
  "./ref.bib",
  title: "Tài liệu tham khảo",
  style: "ieee",
)

#include "./appendix/index.typ"
