#import "@preview/cetz:0.5.2"
#import "html.typ": frame
#import "style.typ": database, family, styled

#let with-hint = sys.inputs.at("hint", default: "false") == "true"
#let is-html = sys.inputs.at("html", default: "false") == "true"

#let unknown = (__tag__: "unknown")
#let pretest = (__tag__: "pretest")

#let Var = math.class("normal", "Var")
#let Cov = math.class("normal", "Cov")
#let Bin = math.class("normal", math.italic("Bin"))
#let Po = math.class("normal", math.italic("Po"))

#let ana(x) = [
  #sym.paren.l
  #sym.space
  #sym.space
  #x
  #sym.space
  #sym.space
  #sym.paren.r
]

#let _opt_ = text.with(
  weight: "bold",
  font: family.sans,
)

#let answer-circle = if not is-html and with-hint {
  circle.with(
    height: 1em,
    width: 1em,
    inset: -1.5pt,
    outset: 2pt,
    stroke: red,
  )
} else { x => x }

#let __inner-option-counter__ = counter("__inner-option-counter__")

#let options(a: none, body) = context {
  __inner-option-counter__.step()
  let all = type(a) == array
  let in-a(i) = (
    (type(a) == array and (a.contains(i) or a.contains(numbering("ア", i)))) or i == a or numbering("ア", i) == a
  )
  show enum: it => if is-html {
    html.fieldset(
      style: styled(
        display: "flex",
        flex-direction: "column",
        gap: "4pt",
        width: "fit-content",
        min-width: "0",
        max-width: "100%",
        padding-right: "1em",
        overflow-x: "hidden",
      ),
      {
        html.legend(if all { "選択肢（全て）" } else { "選択肢" })
        it
          .children
          .enumerate()
          .map(((i, it)) => {
            html.label(
              style: styled(
                display: "flex",
                flex-direction: "row",
                gap: "4pt",
                align-items: "center",
              ),
              {
                html.input(
                  style: styled(display: "block"),
                  type: if all { "checkbox" } else { "radio" },
                  value: i,
                  name: str(__inner-option-counter__.get().first()),
                  checked: in-a(i + 1),
                  disabled: true,
                )
                html.b(style: styled(display: "block"), numbering("ア", i + 1))
                html.div(style: styled(overflow-x: "auto"), it.body)
              },
            )
          })
          .join()
      },
    )
  } else { it }
  set enum(
    numbering: n => if in-a(n) {
      answer-circle(
        text(
          weight: "bold",
          font: family.sans,
          numbering("ア", n),
        ),
      )
    } else {
      text(
        weight: "bold",
        font: family.sans,
        numbering("ア", n),
      )
    },
    body-indent: 2em,
  )
  body
}

#let data(years, p: none) = {
  set text(size: 8pt)
  set par(first-line-indent: 0em)
  let before = {
    [出題：]
    if type(years) == array {
      if years.any(year => type(year) == array) {
        years
          .map(year => if type(year)
            == array [#year.first()年 #("春中間", "春期末", "夏中間", "夏期末").at(year.last() - 1)])
          .join("、")
      } else [#years.first()年 #("春中間", "春期末", "夏中間", "夏期末").at(years.last() - 1)]
    } else if years == pretest [小テスト] else if years == unknown [詳細不明]
  }
  let after = if p != none {
    [教科書：]
    if type(p) == array {
      if p.any(x => (
        type(x) == array
      )) [pp. #p.map(x => if type(x) == array { if x.first() == x.last() [#x.first()] else [#x.first() - #x.last()] } else [#x]).join(", ")] else if (
        p.first() == p.last()
      ) [p. #p.first()] else [pp. #p.first() - #p.last()]
    } else [p. #p]
  }
  if is-html {
    html.small(style: styled(display: "flex", width: "100%", justify-content: "space-between", flex-wrap: "wrap"), {
      html.span(before)
      html.span(after)
    })
  } else {
    before
    if type(years) == array and years.len() > 5 { parbreak() }
    h(1fr)
    after
  }
}

#let rchead(r, c) = {
  place(bottom + left, r)
  place(top + right, c)
  place(line(stroke: black, start: (20%, 20%), end: (80%, 80%)))
}

#let ans(body) = if is-html {
  html.details(style: "margin: 1em 0;", {
    html.summary("解答", style: "cursor: pointer;")
    html.div(body)
  })
} else if with-hint {
  set enum(indent: .5em)
  block(
    stroke: black,
    inset: (x: 0em, y: .5em),
    outset: (x: 1em, y: .5em),
    width: 100%,
    body,
  )
}

#let eqref(ref, body) = {
  [
    #math.equation(
      block: true,
      numbering: num => if not is-html {
        numbering(
          "(1.1)",
          counter(heading).get().first(),
          num,
        )
      },
      number-align: right + horizon,
      body
        + if is-html {
          (
            sym.space.nobreak
              + context numbering(
                "(1)",
                counter(math.equation).get().first(),
              )
          )
        },
    )
    #ref
  ]
}
