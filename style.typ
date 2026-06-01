#let style(body) = {
  import "typ/templates/okiken.typ": *
  import "typ/utils/replace.typ": *
  show: okiken-style.with(
    progress-char: emoji.fingers.pinch,
    title-color-map: color.map.icefire,
    fn-numbering: "[編者注:1]",
  )
  show: replace

  set page("a4")

  set list(indent: 2em, spacing: 1em)
  set terms(indent: 2em, spacing: 1em)
  set enum(indent: 2em, numbering: "(1-a)", spacing: 1em)
  set grid(gutter: 2em, align: top)
  show raw: set text(size: 11pt)
  show heading.where(level: 1, outlined: true): it => {
    pagebreak()
    it
  }
  show math.equation: it => math.display(it)

  body
}
