#import "/style/html.typ": style
#set document(title: "目次")
#show: style.with(doc-type: "website")

#title()

#let appendix = yaml("/appendix.yaml")

#for (name, subject) in yaml("/appendix.yaml") {
  heading(level: 1, subject.at("title"))
  list(..subject.at("chapters").map(chapter => link("./" + name + "/" + chapter, chapter)))
}
