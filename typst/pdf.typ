#import "/typst/style.typ": style

#let __srcdir__ = sys.inputs.at("srcdir")
#let __content__ = yaml("/appendix.yaml").at(__srcdir__)
#let __remarks__ = __content__.at("remarks", default: none)

#set document(title: __content__.at("title"))
#show: style

#title()
#if __remarks__ != none { par("備考。" + __remarks__) }
#outline()
#for name in __content__.at("chapters") {
  include "/src/~/chapters/*.typ".replace("~", __srcdir__).replace("*", name)
}
