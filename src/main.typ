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

#show raw: it => {
  if it.block {
    set text(size: 9pt)
    it
  } else {
    set text(size: 9pt)
    show regex("[._/,\-()=]"): char => char + sym.zws
    it
  }
}

#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): it => {
  pagebreak()
  upper(it)
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
  margin: (
    top: 3cm,
    bottom: 3.5cm,
    left: 3.5cm,
    right: 2cm,
  ),
)

#include "./thanks.typ"

#context {
  let loc = query(<end-content>)

  let target = if loc.len() > 0 {
    selector(heading).before(loc.first().location())
  } else {
    heading
  }

  let target-appendix = if loc.len() > 0 {
    selector(heading).after(loc.first().location())
  } else {
    heading
  }

  {
    show outline.entry.where(level: 1): set text(weight: "bold")
    show outline.entry.where(level: 1): it => {
      v(12pt, weak: true)
      let elem = it.element

      let new-prefix = if elem.numbering != none {
        [#elem.supplement #it.prefix()]
      } else {
        none
      }

      show link: set text(fill: luma(0%))
      link(
        elem.location(),
        it.indented(new-prefix, it.inner()),
      )
    }
    outline(
      depth: 3,
      indent: 1em,
      target: target,
    )
  }
  outline(
    title: "Danh mục hình ảnh",
    target: figure
      .where(
        kind: image,
      )
      .before(
        loc.first().location(),
        inclusive: false,
      ),
  )

  outline(
    title: "Danh mục bảng biểu",
    target: figure
      .where(
        kind: table,
      )
      .before(
        loc.first().location(),
        inclusive: false,
      ),
  )

  // outline(
  //   title: "Danh mục bảng chương trình",
  //   target: figure
  //     .where(
  //       kind: raw,
  //     )
  //     .before(
  //       loc.first().location(),
  //       inclusive: false,
  //     ),
  // )

  // outline(
  //   title: "Phụ lục",
  //   depth: 2,
  //   target: heading
  //     .where(supplement: [Phụ lục], level: 2)
  //     .or(heading.where(supplement: [Phụ lục], level: 3))
  //     .and(target-appendix),
  // )
}

#import "@preview/codly:1.3.0": *
#show: codly-init.with()
#codly(
  zebra-fill: none,
)

#include "./glossaries.typ"

#include "summary.typ"

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

#{
  set heading(numbering: "1.")

  set heading(supplement: [Chương])

  show heading.where(level: 1): it => context {
    pagebreak()
    align(center, [
      #if it.numbering != none [
        #it.supplement #counter(heading).display(it.numbering)
      ]
      #upper(it.body)
    ])
  }

  show heading: it => context {
    if it.level <= 3 {
      it
    } else {
      it.body
    }
  }
  include "./chapter1/index.typ"

  include "./chapter2/index.typ"

  include "./chapter3/index.typ"

  include "./chapter4/index.typ"

  include "./chapter5/index.typ"

  [#metadata(none)<end-content>]
}

#include "./references.typ"

//#include "./appendix/index.typ"
