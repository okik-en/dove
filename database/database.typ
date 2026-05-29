#import "../style.typ": style
#show: style

#import "../utils.typ": database
#show grid: set figure(kind: database)
#show figure.where(kind: database): set figure(supplement: none)
#show figure.where(kind: database): set figure.caption(position: top)

#set document(title: "データベース")

#title()
#outline()
#include "chapters/about-database.typ"
#include "chapters/relational-data-model.typ"
#include "chapters/operation-description.typ"
#include "chapters/sql.typ"
#include "chapters/relational-database-design.typ"
#include "chapters/normalization.typ"
#include "chapters/database-management-system.typ"
#include "chapters/query-optimization.typ"
#include "chapters/transaction.typ"
#include "chapters/parallel-execution-protocol.typ"
#include "chapters/bigdata-and-nosql.typ"
