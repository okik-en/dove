#import "@preview/cjk-spacer:0.2.1": cjk-spacer
#import "fix-indent.typ": *

#let emoji-regex = regex("[\u{2600}-\u{27BF}\u{1F000}-\u{1FFFF}]")

#let fonts = (
  serif: "New Computer Modern",
  serif-cjk: "Yu Mincho",
  sans: "Arial",
  sans-cjk: "Yu Gothic",
  mono: "Fira Code",
  mono-cjk: "Yu Gothic UI",
  math: "New Computer Modern Math",
  emoji: "Noto Emoji",
)

#let family = (
  serif: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.serif, covers: "latin-in-cjk"), fonts.serif-cjk),
  sans: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.sans, covers: "latin-in-cjk"), fonts.sans-cjk),
  mono: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.mono, covers: "latin-in-cjk"), fonts.mono-cjk),
  math: (fonts.math, (name: fonts.serif, covers: "latin-in-cjk"), fonts.serif-cjk),
)

#let database = "__database__"

#let styled(..args) = args.named().pairs().map(((k, v)) => k + ": " + v + ";").join(" ")

#let style(body) = {
  set text(lang: "ja")
  show: cjk-spacer
  show: fix-indent
  set page(
    paper: "a4",
    margin: (left: 25mm, right: 25mm, top: 30mm, bottom: 30mm),
    header: text(size: 8pt, [
      Last compiled on: #datetime.display(datetime.today(), "[year]/[month]/[day] ([weekday])").
      #h(1fr)
      This work by
      #link("https://github.com/okik-en", "okik-en")
      is permitted for use for personal purposes only.
    ]),
    footer: context {
      align(center, text(
        font: family.serif,
        size: 8pt,
        style: "italic",
        lang: "en",
        number-type: "old-style",
        number-width: "tabular",
      )[
        #counter(page).get().first()
        of
        #counter(page).final().first()
      ])
    },
  )

  //* MARK:フォント関連

  set text(
    font: family.serif,
    cjk-latin-spacing: auto,
    top-edge: "ascender",
    bottom-edge: "descender",
    number-type: "lining",
    number-width: "tabular",
  )
  show title: set text(font: family.sans)
  show heading: set text(font: family.sans)
  show strong: set text(font: family.sans)
  show raw: set text(font: family.mono)
  show math.equation: set text(font: family.math)

  //* MARK:カウンタ関連

  // カウンタリセット
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }

  set heading(numbering: "1.1.1.")
  show footnote: it => panic("Footnotes are not supported in this document.")
  set figure(
    numbering: num => numbering("1.1", counter(heading).get().first(), num),
  )
  show figure.where(kind: image): set figure(supplement: [図])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: raw): set figure(supplement: [コード])

  // 数式番号 (通常は表示しない)
  set math.equation(numbering: none)
  show math.equation: it => math.display(it)

  //* MARK:スタイルシート

  show title: it => block(
    inset: 2pt,
    text(top-edge: "x-height", bottom-edge: "descender", tracking: 1pt, it),
  )
  show link: set text(blue)
  set par(first-line-indent: (amount: 1em, all: true), justify: true, leading: .8em)
  set list(indent: 2em, body-indent: 0.4em, spacing: 1em)
  set enum(indent: 2em, body-indent: 0.4em, spacing: 1em, numbering: "(1-a)")
  set grid(gutter: 2em, align: top)
  show raw: set text(size: 11pt)
  show heading.where(level: 1, outlined: true): it => {
    pagebreak()
    it
  }
  show figure.where(kind: database): set figure(supplement: none)
  show figure.where(kind: database): set figure.caption(position: top)

  body
}
