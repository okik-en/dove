#import "../typst/style.typ": style
#show: style

#set document(title: "確率統計")

#title()
備考。
過去に共通テストやセンター試験（追試験を含む！）から出題されていた例が多くあるので、予め解いておくとよいだろう。
#outline()

#for name in yaml("appendix.yaml") {
  include "chapters/*.typ".replace("*", name)
}
