// source: https://github.com/maucejo/elsearticle/blob/main/src/els-environment.typ

#let appendix(body) = {
  set heading(numbering: "A.1.", supplement: [Phụ lục])
  counter(heading).update(0)

  let numbering-eq = (..n) => {
    let h1 = counter(heading).get().first()
    numbering("(A.1a)", h1, ..n)
  }
  set math.equation(numbering: numbering-eq)

  let numbering-fig = n => {
    let h1 = counter(heading).get().first()
    numbering("A.1", h1, n)
  }

  set figure(numbering: numbering-fig)

  body
}
