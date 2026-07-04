#import "/style/html.typ": style, styled
#set document(title: "目次")

#show: style.with(doc-type: "website")

#title()

#let appendix = yaml("/appendix.yaml")

#for (name, subject) in yaml("/appendix.yaml") {
  heading(level: 1, subject.at("title"))
  list(..subject.at("chapters").map(((path, label)) => link("./" + name + "/" + path, label)))
}
