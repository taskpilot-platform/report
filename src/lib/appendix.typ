// source: https://github.com/maucejo/elsearticle/blob/main/src/els-environment.typ

#let appendix(body) = {
  set heading(
    numbering: (..nums) => {
      let n = nums.pos()
      if n.len() == 1 {
        none
      } else if n.len() == 2 {
        numbering("A", n.at(1))
      } else if n.len() == 3 {
        numbering("A.1.", n.at(1), n.at(2))
      } else {
        numbering("A.1.1.", n.at(1), n.at(2), n.at(3))
      }
    },
    supplement: [Phụ lục],
  )
  counter(heading).update(0)

  show heading.where(level: 2): it => context {
    let idx = counter(heading).get().at(1)
    if idx > 1 { pagebreak() }

    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    let letter = numbering("A", idx)
    [Phụ lục #letter. #it.body]
  }

  let numbering-eq = (..n) => {
    let h = counter(heading).get()
    let idx = if h.len() >= 2 { h.at(1) } else { h.first() }
    numbering("(A.1a)", idx, ..n)
  }
  set math.equation(numbering: numbering-eq)

  let numbering-fig = n => {
    let h = counter(heading).get()
    let idx = if h.len() >= 2 { h.at(1) } else { h.first() }
    numbering("A", idx) + str(n)
  }
  set figure(numbering: numbering-fig)

  body
}
