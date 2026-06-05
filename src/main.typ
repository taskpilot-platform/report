#import "./lib/metadata.typ": project-metadata

#set document(
  title: project-metadata.title,
  author: project-metadata.authors,
  keywords: project-metadata.keywords,
)

#set page(
  paper: "a4",
  margin: (left: 3.5cm, right: 2cm, top: 2cm, bottom: 2cm),
)

#set text(
  font: "SVN-Times New Roman 2",
  size: 13pt,
  lang: "vi",
  top-edge: "ascender",
  bottom-edge: "descender",
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
  leading: 0.4em,
  spacing: 0.7em,
)

#set heading(numbering: "1.1.1.")

#show heading.where(level: 1): set heading(supplement: [Chương])

#show heading.where(level: 1): it => context {
  pagebreak()
  if it.numbering != none {
    let nums = counter(heading).get()
    align(center, [#it.supplement #nums.at(0). #upper(it.body)])
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

#set figure(
  numbering: (..num) => {
    numbering("1.1", counter(heading).get().first(), num.pos().first())
  },
)
#show figure.caption: emph
#show figure.caption: set text(gray.darken(50%), size: 11pt)
#show figure.where(kind: table): set figure.caption(position: top)

#set par(first-line-indent: (amount: 1em, all: false))

#include "./coverpage.typ"

#include "./thanks.typ"

#outline(title: "Mục lục", depth: 3)

#outline(title: "Danh mục hình ảnh", target: figure.where(kind: image))

#outline(title: "Danh mục bảng biểu", target: figure.where(kind: table))

#outline(title: "Danh mục bảng chương trình", target: figure.where(kind: raw))

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
#counter(page).update(1)

#show link: set text(fill: blue.darken(30%))

#show raw: set text(size: 9pt)
// This take no effect because of codly
#show raw.where(block: true): set par(
  leading: 0.3em,
)

#import "@preview/codly:1.3.0": *
#show: codly-init.with()
#codly(zebra-fill: none)

// #show raw.where(block: true): it => block(
//   stroke: 0.5pt + black,
//   inset: 10pt,
//   radius: 4pt,
//   width: 100%,
//   align(left, it),
// )

#include "./glossaries.typ"

#include "summary.typ"

#include "./chapter1/index.typ"

#include "./chapter2/index.typ"

#include "./chapter3/index.typ"

#include "./chapter4/index.typ"

#include "./chapter5/index.typ"

// #show bibliography: set heading(numbering: none)
#bibliography("./ref.bib", title: "Tài liệu tham khảo", style: "ieee")
