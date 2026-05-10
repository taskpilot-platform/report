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

#set par(justify: true)

#set heading(numbering: "1.1.1.")

#show heading.where(level: 1): set heading(supplement: [Chương])

#show heading.where(level: 1): it => context {
  if it.numbering != none {
    let nums = counter(heading).get()
    align(center, upper([#it.supplement #nums.at(0). #it.body]))
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

#show figure.caption: emph
#show figure.caption: set text(gray.darken(50%), size: 11pt)

#set par(first-line-indent: (amount: 1em, all: false))

#include "./coverpage.typ"
#pagebreak()

#include "./thanks.typ"
#pagebreak()

#outline(title: "Mục lục", depth: 3)
#pagebreak()

#outline(title: "Danh mục hình ảnh", target: figure.where(kind: image))
#pagebreak()

#outline(title: "Danh mục bảng biểu", target: figure.where(kind: table))
#pagebreak()

#outline(title: "Danh mục bảng chương trình", target: figure.where(kind: raw))
#pagebreak()

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

#show raw: set text(size: 9pt)

#show raw.where(block: true): it => block(
  stroke: 0.5pt + black,
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  align(left, it),
)

#show link: set text(fill: blue.darken(30%))

#include "summary.typ"
#pagebreak()

#include "./chapter1/index.typ"
#pagebreak()

#include "./chapter2/index.typ"
#pagebreak()

#include "./chapter3/index.typ"
#pagebreak()

#include "./chapter4/index.typ"
#pagebreak()

#include "./chapter5/index.typ"
#pagebreak()

#include "./glossaries.typ"
#pagebreak()

#show bibliography: set heading(numbering: "1.")
#bibliography("./ref.bib", title: "Tài liệu tham khảo", style: "ieee")
