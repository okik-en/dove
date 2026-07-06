#import "/style/html.typ": style, styled
#set document(title: "目次")

#show: style.with(doc-type: "website")

#title()

#let appendix = yaml("/appendix.yaml")

#for (name, subject) in yaml("/appendix.yaml") {
  heading(level: 1, subject.at("title"))
  list(..subject.at("chapters").map(((path, label)) => link("./" + name + "/" + path, label)))
}

#divider()

#html.small[Report any errors/issues on #link("https://github.com/okik-en/dove/issues", "our repository") .
  Last updated at #html.span(id: "updated_at") .]

#html.script(
  "(async () => document.getElementById('updated_at').textContent = await fetch('https://api.github.com/repos/okik-en/dove/deployments').then(x => x.json()).then(x => new Date(Date.parse(x[0].updated_at)).toLocaleString()))();",
)
