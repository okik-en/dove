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

#html.small[Report any errors/issues on #{ link("https://github.com/okik-en/dove/issues", "our repository") }.
  #{ html.span(id: "last_updated", "") }]

#html.script(
  "(async () => document.getElementById('last_updated').textContent = await fetch('https://api.github.com/repos/okik-en/dove/deployments').then(x => x.json()).then(x => `This site was last updated at ${new Date(Date.parse(x[0].updated_at)).toLocaleString()}.`))();",
)
