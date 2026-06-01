#import "typ/templates/okiken.typ": eqref, family

#let database = "__database__"
#let unknown = (__tag__: "unknown")
#let pretest = (__tag__: "pretest")

#let Var = math.class("normal", "Var")
#let Cov = math.class("normal", "Cov")
#let Bin = math.class("normal", math.italic("Bin"))
#let Po = math.class("normal", math.italic("Po"))

#let ana(x) = [
  (
  #h(1em)
  #x
  #h(1em)
  )
]

#let _opt_ = text.with(
  weight: "bold",
  font: family.sans,
)

#let options(body) = {
  set enum(
    numbering: n => text(
      weight: "bold",
      font: family.sans,
      numbering("ア", n),
    ),
    body-indent: 2em,
  )
  body
}

#let data(years, p: none) = {
  set text(size: 8pt)
  set par(first-line-indent: 0em)
  [出題：]
  if type(years) == array {
    if years.any(year => type(year) == array) {
      years
        .map(year => if type(year)
          == array [#year.first()年 #("春中間", "春期末", "夏中間", "夏期末").at(year.last() - 1)])
        .join("、")
    } else [#years.first()年 #("春中間", "春期末", "夏中間", "夏期末").at(years.last() - 1)]
  } else if years == pretest [小テスト] else if years == unknown [詳細不明]
  if type(years) == array and years.len() > 6 { parbreak() }
  h(1fr)
  if p != none {
    [教科書：]
    if type(p) == array {
      if p.any(x => (
        type(x) == array
      )) [pp. #p.map(x => if type(x) == array { if x.first() == x.last() [#x.first()] else [#x.first() - #x.last()] } else [#x]).join(", ")] else if (
        p.first() == p.last()
      ) [p. #p.first()] else [pp. #p.first() - #p.last()]
    } else [p. #p]
  }
}

#let rchead(r, c) = {
  place(bottom + left, r)
  place(top + right, c)
  place(line(stroke: red, start: (20%, 20%), end: (80%, 80%)))
}

#let ans(body) = if not sys.inputs.keys().contains("no-hint") {
  set text(red)
  set enum(indent: .5em)
  block(
    stroke: red,
    inset: (x: 0em, y: .5em),
    outset: (x: 1em, y: .5em),
    width: 100%,
    body,
  )
}
