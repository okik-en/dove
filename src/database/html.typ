#import "/typst/html.typ": style
#import "/typst/utils.typ": database
#show grid: set figure(kind: database)
#show figure.where(kind: database): set figure(supplement: none)
#show figure.where(kind: database): set figure.caption(position: top)

#set document(title: "データベース")
#show: style

#title()

#for name in yaml("/appendix.yaml").at("database").at("chapters") {
  include "chapters/*.typ".replace("*", name)
}
