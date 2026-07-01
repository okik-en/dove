#import "/typst/html.typ": style
#set document(title: "確率統計")
#show: style

#title()

#for name in yaml("/appendix.yaml").at("probability-and-statistics").at("chapters") {
  include "chapters/*.typ".replace("*", name)
}
