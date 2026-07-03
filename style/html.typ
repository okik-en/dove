#import "style.typ": database, styled
#let __svg__ = state("__svg__", false)

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


#let frame(it) = context {
  __svg__.update(_ => true)
  if sys.inputs.keys().contains("html") and sys.inputs.html == "true" {
    html.div(
      style: styled(
        width: "fit-content",
        background-color: "white",
        margin: ".5em",
        padding: ".5em",
        overflow-x: "auto",
      ),
      html.frame(it),
    )
  } else { it }
  __svg__.update(_ => false)
}

#let style(doc-type: "article", body) = context {
  set text(lang: "ja")

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

  set heading(numbering: "1.1.1.")
  show figure.where(kind: image): set figure(supplement: [図])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: raw): set figure(supplement: [コード])

  // 数式番号 (通常は表示しない)
  set math.equation(numbering: none)
  show math.equation: it => math.display(it)

  // 図をHTMLで表示する際のスタイル
  show table: it => if it.stroke == none { it } else { frame(it) }

  // 画像
  show image: frame

  //* MARK:スタイルシート

  show title: it => block(
    inset: 2pt,
    text(top-edge: "x-height", bottom-edge: "descender", tracking: 1pt, it),
  )
  show link: set text(blue)
  set par(first-line-indent: (amount: 1em, all: true), justify: true, leading: .8em)
  set list(indent: 2em, body-indent: 0.4em, spacing: 1em)
  set enum(indent: 2em, body-indent: 0.4em, spacing: 1em, numbering: "(1-a)")
  show terms: it => html.dl({
    it
      .children
      .map(el => html.div(style: styled(display: "flex", gap: "4pt"), {
        html.dt(html.strong(el.term))
        html.dd(style: styled(margin-inline-start: "0pt"), el.description)
      }))
      .join()
  })
  show raw: set text(size: 11pt)
  show strong: it => html.elem("strong", it)
  show figure.where(kind: database): set figure(supplement: none)
  show figure.where(kind: database): set figure.caption(position: top)

  show math.frac.where(style: "horizontal"): it => math.paren.l + it.num + math.slash + it.denom + math.paren.r
  show math.frac.where(style: "skewed"): it => math.paren.l + it.num + math.slash + it.denom + math.paren.r
  show math.underline: it => html.elem(
    "mstyle",
    attrs: (style: styled(border-bottom: "1pt solid currentColor", padding: "0pt 1pt 2pt")),
    it.body,
  )
  show math.overline: it => html.elem(
    "mstyle",
    attrs: (style: styled(border-top: "1pt solid currentColor", padding: "2pt 1pt 0pt")),
    it.body,
  )

  html.html(lang: "ja", {
    // <head> ~ </head>
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      if query(<title>).len() > 0 {
        html.title(query(<title>).first().value)
      } else {
        html.title(repr(document.title).slice(1, -1))
      }
      html.elem("meta", attrs: (property: "og:title", content: repr(document.title).slice(1, -1)))
      if document.description != none {
        html.meta(name: "description", content: repr(document.description))
        html.elem("meta", attrs: (property: "og:description", content: repr(document.description)))
      }
      html.elem("meta", attrs: (
        property: "og:image",
        content: "https://raw.githubusercontent.com/okik-en/mathematical-documents/master/okik-en.png",
      ))
      html.elem("meta", attrs: (property: "og:type", content: doc-type))
      html.elem("meta", attrs: (
        property: "og:site_name",
        content: "dove",
      ))
      html.elem("meta", attrs: (
        property: "og:locale",
        content: "ja_JP",
      ))
      html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
      html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")
      html.link(
        href: "https://fonts.googleapis.com/css2?family=Noto+Emoji:wght@300..700&family=Noto+Sans:ital,wght@0,100..900;1,100..900&family=Noto+Sans+Math&family=Noto+Sans+Mono:wght@100..900&display=swap",
        rel: "stylesheet",
      )
      html.link(rel: "stylesheet", href: "https://cdn.simplecss.org/simple.css")
      html.style(
        (
          "body { font-family: 'Noto Sans', 'Noto Emoji', sans-serif; }",
          "math { font-family: 'Noto Sans Math', 'Noto Emoji', math; padding: 1pt; }",
          "code { font-family: 'Noto Sans Mono', 'Noto Emoji', monospace; }",
          "math, pre { overflow-x: auto; overflow-y: hidden; max-width: 100%; }",
          "a { text-decoration: none; display: inline-block; border-bottom: 1pt currentColor solid; } ",
          "li p:first-child { display: inline; }",
          "ol { list-style-type: none; counter-reset: dec; }",
          "ol > li { counter-increment: dec; }",
          "ol > li:before { content: '(' counter(dec, decimal) ') '; }",
          "ol ol { list-style-type: none; counter-reset: llt; }",
          "ol ol > li { counter-increment: llt; }",
          "ol ol > li:before { content: '(' counter(dec, decimal) '-' counter(llt, lower-latin) ') '; }",
        ).join("\n"),
      )
    })
    // <body> ~ </body>
    html.body(html.main(body))
  })
}
