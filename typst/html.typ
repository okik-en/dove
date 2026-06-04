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


#let frame(tag: "div", it) = context {
  __svg__.update(_ => true)
  if sys.inputs.keys().contains("html") and sys.inputs.html == "true" {
    html.elem(tag, html.frame(it))
  } else { it }
  __svg__.update(_ => false)
}

#let style(body) = context {
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

  // カウンタリセット
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }

  set heading(numbering: "1.1.1.")
  set figure(
    numbering: num => numbering("1.1", counter(heading).get().first(), num),
  )
  show figure.where(kind: image): set figure(supplement: [図])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: raw): set figure(supplement: [コード])

  // 数式番号 (通常は表示しない)
  set math.equation(numbering: none)
  show math.equation: it => math.display(it)

  //* MARK: 数式等の調整

  // 図をHTMLで表示する際のスタイル
  show table: frame.with(tag: "table")

  // インライン数式
  show math.equation.where(block: false): it => context {
    if __svg__.get() { it } else {
      html.elem(
        "span",
        attrs: (
          class: "inline",
          role: "math",
          alt: if it.alt == none { repr(it.body).replace(regex("\n\s*"), _ => "") } else { it.alt },
        ),
        html.frame(it),
      )
    }
  }
  // ブロック数式
  show math.equation.where(block: true): it => context {
    if __svg__.get() { it } else {
      html.elem(
        "div",
        attrs: (
          style: "text-align: center;",
          role: "math",
          alt: if it.alt == none { repr(it.body).replace(regex("\n\s*"), _ => "") } else { it.alt },
        ),
        html.frame(it),
      )
    }
  }

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
  show strong: it => html.elem("strong", attrs: (class: "strong"), it)
  show heading.where(level: 1, outlined: true): it => if (
    sys.inputs.keys().contains("html") and sys.inputs.html == "true"
  ) { it } else {
    pagebreak()
    it
  }

  html.html(lang: "ja", {
    // <head> ~ </head>
    html.head({
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      html.title(document.title)
      if document.description != none {
        html.meta(name: "description", content: document.description)
      }
      // html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
      // html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")

      // html.script(src: "script.js")
      // html.link(rel: "stylesheet", href: css-relative-path)
    })
    // <body> ~ </body>
    html.body({
      html.div(class: "container", {
        html.main(body)
        // html.aside(outline())
      })
    })
  })
}
