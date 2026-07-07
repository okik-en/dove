#import "utils.typ": __svg__, frame, myrepr
#import "style.typ": database, styled

#let style(doc-type: "article", body) = context {
  set text(
    lang: "ja",
    font: "Noto Sans JP",
    cjk-latin-spacing: auto,
    top-edge: "ascender",
    bottom-edge: "descender",
    number-type: "lining",
    number-width: "tabular",
  )
  show math.equation: set text(font: "Noto Sans Math")
  show raw: set text(font: ("Noto Sans Mono", "Noto Sans JP"))

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
      html.title(myrepr(document.title))
      html.elem("meta", attrs: (property: "og:title", content: myrepr(document.title)))
      if document.description != none {
        html.meta(name: "description", content: myrepr(document.description))
        html.elem("meta", attrs: (property: "og:description", content: myrepr(document.description)))
      }
      html.elem("meta", attrs: (
        property: "og:image",
        content: "https://raw.githubusercontent.com/okik-en/mathematical-documents/master/okik-en.png",
      ))
      html.elem("meta", attrs: (property: "og:type", content: doc-type))
      html.elem("meta", attrs: (
        property: "og:site_name",
        content: "dove-ks 打倒",
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
          (
            "body",
            (
              font-family: "'Noto Sans', 'Noto Emoji', sans-serif",
              text-autospace: "normal",
              overflow-wrap: "anywhere",
              word-break: "normal",
              line-break: "strict",
            ),
          ),
          ("p", (text-align: "justify")),
          ("math", (font-family: "'Noto Sans Math', 'Noto Emoji', math", padding: "1pt")),
          ("mtable, mrow", (width: "max-content")),
          ("code", (font-family: "'Noto Sans Mono', 'Noto Emoji', monospace")),
          ("math, pre", (overflow-x: "auto", overflow-y: "hidden", max-width: "100%")),
          ("a", (text-decoration: "none", display: "inline-block", border-bottom: "1pt currentColor solid")),
          ("li p:first-child", (display: "inline")),
          ("ol", (list-style-type: "none", counter-reset: "dec")),
          ("ol > li", (counter-increment: "dec")),
          ("ol > li:before", (content: "'(' counter(dec, decimal) ') '")),
          ("ol ol", (list-style-type: "none", counter-reset: "llt")),
          ("ol ol > li", (counter-increment: "llt")),
          ("ol ol > li:before", (content: "'(' counter(llt, lower-latin) ') '")),
        )
          .map(((selector, rules)) => selector + "{" + styled(..rules) + "}")
          .join("\n"),
      )
    })
    // <body> ~ </body>
    html.body(html.main(body))
  })
}
