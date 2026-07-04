#import "/style/html.typ": style, styled
#let __chapter__ = sys.inputs.at("chapter")
#let __srcdir__ = sys.inputs.at("srcdir")
#let __content__ = yaml("/appendix.yaml").at(__srcdir__)
#let __remarks__ = __content__.at("remarks", default: none)

#let cs = yaml("/appendix.yaml").at(__srcdir__).at("chapters")
#let id = cs.position(s => s == __chapter__) + 1

#let navi = html.nav(style: "display: flex; justify-content: space-between; flex-wrap: wrap; gap: 1em; margin: 2em;", {
  if id > 1 {
    html.elem("a", attrs: (href: "../" + cs.first()), `./first`)
    html.elem("a", attrs: (href: "../" + cs.at(id - 2)), `./prev`)
  } else {
    html.span(`-`)
    html.span(`-`)
  }
  html.elem("a", attrs: (href: "../../"), `../`)
  if id < cs.len() {
    html.elem("a", attrs: (href: "../" + cs.at(id)), `./next`)
    html.elem("a", attrs: (href: "../" + cs.last()), `./last`)
  } else {
    html.span(`-`)
    html.span(`-`)
  }
})

#set document(title: context numbering("1. ", id) + query(<title>).first().value)
#show heading.where(level: 1): it => [
  #metadata(it.body) <title>
  #counter(heading).update(0)
]
#show heading.where(level: 2): it => context html.h2(
  id: str(counter(heading).get().last()),
  style: styled(display: "flex", justify-content: "space-between", align-items: "center"),
  {
    html.span(numbering("1.1.", id, counter(heading).get().last()) + it.body)
    html.elem(
      "a",
      attrs: (
        style: styled(cursor: "pointer", font-size: "1rem"),
        onclick: "navigator.share({title: '"
          + repr(it.body)
          + "', text: 'こんな簡単な問題もわからないなんて…', url: 'https://okik-en.github.io/dove/"
          + __srcdir__
          + "/"
          + __chapter__
          + "#"
          + str(counter(heading).get().last())
          + "'});",
      ),
      `#`,
    )
  },
)
#show: style

#title()

#navi
#include "/src/" + __srcdir__ + "/" + __chapter__ + ".typ"
#navi
