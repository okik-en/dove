#import "../typst/style.typ": style
#show: style

#import "../typst/utils.typ": database
#show grid: set figure(kind: database)
#show figure.where(kind: database): set figure(supplement: none)
#show figure.where(kind: database): set figure.caption(position: top)

#set document(title: "データベース")

#title()
#outline()

#for name in yaml("appendix.yaml") {
  include "chapters/*.typ".replace("*", name)
}
