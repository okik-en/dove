#import "/style/utils.typ": *

= リレーショナルデータベースの操作記述

== 集合演算

#data(((2021, 1), (2024, 1)), p: (34, 37))

+ 次の関係$R$、$S$、$T$、$U$において、
  関係代数表現$R times S div T - U$の演算結果を与えなさい。
  ここで、$times$は直積、$div$は商、$-$は差の演算を表す。
  答えは直接図表で与えること。
  #figure(
    table(
      stroke: none,
      columns: 4,
      figure(
        kind: database,
        caption: [関係$R$],
        table(
          columns: 2,
          table.header($A$, $B$),
          $1$, $a$,
          $2$, $b$,
          $3$, $a$,
          $3$, $b$,
          $4$, $a$,
        ),
      ),
      figure(
        kind: database,
        caption: [関係$S$],
        table(
          columns: 1,
          table.header($C$),
          $x$,
          $y$,
        ),
      ),
      figure(
        kind: database,
        caption: [関係$T$],
        table(
          columns: 1,
          table.header($A$),
          $1$,
          $3$,
        ),
      ),
      figure(
        kind: database,
        caption: [関係$U$],
        table(
          columns: 2,
          table.header($B$, $C$),
          $a$, $x$,
          $c$, $z$,
        ),
      ),
    ),
  )
+ 商（$div$）演算が表している意味を、直感的な言葉で説明しなさい。

== リレーショナル演算

#data(((2021, 2), (2022, 1), (2023, 1), (2025, 1)), p: (34, 43))

関係データベースのデータ操作機能を組み合わせると、
次の"商品"表から"価格"表を得ることができる。
このときに用いるデータ操作機能の組合せとして、正しいものはどれか。

#figure(
  table(
    stroke: none,
    columns: 2,
    figure(
      kind: database,
      caption: [商品],
      table(
        columns: 4,
        table.header([コード], [商品名], [定価], [割引率]),
        $011$, [ノート], $#sym.yen 100$, $20%$,
        $012$, [鉛筆], $#sym.yen 50$, $10%$,
        $013$, [消しゴム], $#sym.yen 20$, $10%$,
        $020$, [定規], $#sym.yen 80$, $20%$,
      ),
    ),
    figure(
      kind: database,
      caption: [価格],
      table(
        columns: 2,
        table.header([商品名], [価格]),
        [消しゴム], $#sym.yen 18$,
        [鉛筆], $#sym.yen 45$,
        [定規], $#sym.yen 64$,
        [ノート], $#sym.yen 80$,
      ),
    ),
  ),
)

#options(a: 3)[
  + 結合、四則演算、射影
  + 結合、射影、整列
  + 四則演算、射影、整列
  + 射影、整列、選択
]

== リレーショナル演算

#data(((2021, 2), (2022, 1), (2023, 1), (2025, 1)), p: (34, 43))

3つの関係表がある。
- 納入(#underline[商品番号], #underline[顧客番号], 納品数量)
- 商品(#underline[商品番号], 商品名, 仕様)
- 顧客(#underline[顧客番号], 顧客名, 住所)

納入表は、ある期間中に我が社がどんな製品を誰に納入したかを示す。
商品表は、それぞれの商品に関する詳細情報を、
また顧客表はそれぞれの顧客に関する詳細情報を示す。
#underline[下線部]は主キーを表す。
この3つの関係表から、我が社が商品を納入した顧客の、顧客名と商品名とを知りたい。
この計算に必要な関係(リレーシナル)代数演算を与えなさい。
