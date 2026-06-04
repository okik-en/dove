#import "../../typst/utils.typ": *

= 同時実行制御

== 同時実行制御の必要性

#data(((2023, 3), (2024, 3)), p: (151, 153))

下の図はどのような異常を引き起こすスケジュールの事例であるか、その異常名とその原因の解析を、
図に従って説明しなさい。

#figure(
  caption: [`A`は夫婦共通の口座$A$の残高を表す。],
  table(
    columns: (2em,) + (12em,) * 2,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 6 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, $T_1$, $T_2$),
    $t_1$, `read(A)`, [],
    $t_2$, [], `read(A)`,
    $t_3$, `write(A := A - 30)`, [],
    $t_4$, [], `write(A := A - 20)`,
    $t_5$, `COMMIT`, [],
    $t_6$, [], `COMMIT`,
  ),
)

== 同時実行制御の必要性

#data((2023, 4), p: (151, 153))

下の図はどのような異常を引き起こすスケジュールの事例であるか、その異常名と、内容を
図に従って説明しなさい。

#figure(
  caption: [`A`は学生の銀行口座$A$（単位万円）の残高を表す。],
  table(
    columns: (2em,) + (12em,) * 2,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 6 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, [$T_1$ （親元）], [$T_2$ （学生）]),
    $t_1$, `read(A)`, [],
    $t_2$, `write(A := A + 10)`, [],
    $t_3$, [], `read(A)`,
    $t_4$, [], `write(A := A - 10)`,
    $t_5$, [], `COMMIT`,
    $t_6$, `ROLLBACK`, [],
  ),
)

== 同時実行制御の必要性

#data((2023, 3), p: (151, 153))

下の図はどのような障害を説明したものか、その障害名と、原因解析を図に従って説明しなさい。

#figure(
  grid(
    columns: 2,
    figure(
      caption: $T_1$,
      ```
      begin
        read(x)
        read(y)
        write(x)
      end
      ```,
    ),
    figure(
      caption: $T_2$,
      ```
      begin
        read(y)
        read(x)
        write(y)
      end
      ```,
    ),
  ),
)

#figure(
  table(
    columns: (2em,) + (6em,) * 2,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 4 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, $T_1$, $T_2$),
    $t_1$, `lock(x)`, [],
    $t_2$, [], `lock(y)`,
    $t_3$, `read(x)`, [],
    $t_4$, [], `read(y)`,
  ),
)

== 直列可能性

#data((2023, 3), p: (154, 157))

$2$つのトランザクション$T_1$、$T_2$が、データ`a`、`b`に並行してアクセスする。
$T_1$、$T_2$の組合せのうち、直列可能性が保証できるものはどれか。
ここで、トランザクションの各操作の意味は次のとおりとする。

/ `LOCK x`: データ`x`をロックする
/ `READ x`: データ`x`を読み込む
/ `WRITE x`: データ`x`を書き出す
/ `UNLOCK x`: データ`x`をアンロックする

#{
  show raw: set text(8pt)
  figure(
    table(
      columns: 8,
      stroke: none,
      table.cell(colspan: 2, text(font: family.sans, weight: "bold")[ア]),
      table.cell(colspan: 2, text(font: family.sans, weight: "bold")[イ]),
      table.cell(colspan: 2, text(font: family.sans, weight: "bold")[ウ]),
      table.cell(colspan: 2, text(font: family.sans, weight: "bold")[エ]),
      $T_1$, $T_2$, $T_1$, $T_2$, $T_1$, $T_2$, $T_1$, $T_2$,
      ```
      READ a
      LOCK a
      LOCK b
      a = a + 3

      WRITE a
      READ b
      b = b + 5

      WRITE b
      UNLOCK a
      UNLOCK b
      ```,
      ```
      READ a
      LOCK a
      LOCK b
      a = a + 3

      WRITE a
      READ b
      b = b + 5

      WRITE b
      UNLOCK a
      UNLOCK b
      ```,
      ```
      LOCK a
      READ a
      a = a + 3

      WRITE a
      UNLOCK a
      LOCK b
      READ b
      b = b + 5

      WRITE b
      UNLOCK b
      ```,
      ```
      LOCK a
      READ a
      a = a + 3

      WRITE a
      UNLOCK a
      LOCK b
      READ b
      b = b + 5

      WRITE b
      UNLOCK b
      ```,
      ```
      LOCK a
      READ a
      a = a + 3

      WRITE a
      UNLOCK a
      LOCK b
      READ b
      b = b + 5

      WRITE b
      UNLOCK b
      ```,
      ```
      LOCK a
      READ a
      LOCK b
      READ b
      UNLOCK a
      UNLOCK b
      ```,
      ```
      LOCK a
      READ a
      a = a + 3

      WRITE a
      LOCK b
      READ b
      b = b + 5

      WRITE b
      UNLOCK b
      UNLOCK a
      ```,
      ```
      LOCK a
      READ a
      LOCK b
      READ b
      UNLOCK b
      UNLOCK a
      ```,
    ),
  )
}

== 2相ロッキングプロトコル

#data((2023, 3), p: (163, 165))

2相ロッキングプロトコルに従ってロックを獲得するトランザクション$A$、$B$を
図のように同時実行した場合に、デッドロックが発生しないデータ処理順序はどれか。
ここで、`read`と`update`の位置は，アプリケーションプログラムでの命令発行時点を表す。
また、データ`W`への`read`は共有ロックを要求し、
データ`X`、`Y`、`Z`への`update`は各データへの専有ロックを要求する。

#figure(
  table(
    columns: (2em,) + (6em,) * 2,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 8 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, $A$, $B$),
    $t_1$, `read W`, [],
    $t_2$, [], `( 1 )`,
    $t_3$, `update X`, [],
    $t_4$, [], `( 2 )`,
    $t_5$, `update Y`, [],
    $t_6$, [], `( 3 )`,
    $t_7$, `update Z`, [],
    $t_8$, [], `( 4 )`,
  ),
)

#figure(
  table(
    align: center,
    columns: (3em,) + (6em,) * 4,
    [], `( 1 )`, `( 2 )`, `( 3 )`, `( 4 )`,
    text(font: family.sans, weight: "bold")[ア], `read W`, `update Y`, `update X`, `update Z`,
    text(font: family.sans, weight: "bold")[イ], `read W`, `update Y`, `update Z`, `update X`,
    text(font: family.sans, weight: "bold")[ウ], `update X`, `read W`, `update Y`, `update Z`,
    text(font: family.sans, weight: "bold")[エ], `update Y`, `update Z`, `update X`, `read W`,
  ),
)

== 専有ロックと共有ロック

#data((2022, 3), p: 165)

ロックの両立性に関する記述のうち、適切なものはどれか。
#options[
  + トランザクション$T_1$が共有ロックを獲得している資源に対して、
    トランザクション$T_2$は共有ロックと専有ロックのどちらも獲得することができる。
  + トランザクション$T_1$が共有ロックを獲得している資源に対して、
    トランザクション$T_2$は共有ロックを獲得することはできるが、専有ロックを獲得することはできない。
  + トランザクション$T_1$が専有ロックを獲得している資源に対して、
    トランザクション$T_2$は専有ロックと共有ロックのどちらも獲得することができる。
  + トランザクション$T_1$が専有ロックを獲得している資源に対して、
    トランザクション$T_2$は専有ロックを獲得することはできるが、共有ロックを獲得することはできない。
]

== ロック

#data((2023, 3), p: 165)

RDBMSのロックに関する記述のうち、適切なものはどれか。
ここで、$X$、$Y$はトランザクションとする。
#options[
  + $X$が$A$表内の特定行$a$に対して共有ロックを獲得しているときは、
    $Y$は$A$表内の別の特定行$b$に対して専有ロックを獲得することができない。
  + $X$が$A$表内の特定行$a$に対して共有ロックを獲得しているときは、
    $Y$は$A$表に対して専有ロックを獲得することができない。
  + $X$が$A$表に対して共有ロックを獲得しているときでも、
    $Y$は$A$表に対して専有ロックを獲得することができる。
  + $X$が$A$ 表に対して専有ロックを獲得しているときでも、
    $Y$は$A$表内の特定行$a$に対して専有ロックを獲得することができる。
]

== 同時トランザクション

#data(((2022, 3), (2023, 3), (2024, 3), (2025, 4)), p: (159, 165))

以下のトランザクション$T_1$と$T_2$の同時実行制御につき、次の問に答えなさない。

#figure(
  grid(
    columns: 2,
    figure(
      caption: $T_1$,
      ```
      begin
        read(x)
        write(x)
      end
      ```,
    ),
    figure(
      caption: $T_2$,
      ```
      begin
        read(y)
        read(x)
        write(y)
      end
      ```,
    ),
  ),
)

+ $T_1$と$T_2$とを同時に実行する非直列スケジュールを全て示しなさい。
  ただし、それらは$T_1$の第一ステップから実行を開始するとする。
+ (1)で得られた非直列スケジュールのうち、2相ロッキングプロトコル(2PL)に従った場合に、
  実行されるスケジュールはどれか、理由も含めて説明しなさい。
+ (2)で得られた非直列スケジュールのうち、トランザクション$T_1$と$T_2$とを2PLに従い、
  実行させた時のスケジュールを示しなさい。
+ (2)で得られたスケジュールの相反グラフを与えなさい。
+ (4)で得られた相反グラフをトポロジカルソートすると、(3)で得られたスケジュールに等価な
  直列スケジュールが得られる。それを与えなさい。

== デッドロック

#data((2022, 3), p: (166, 168))

三つのトランザクション$T_1$、$T_2$、$T_3$が、$t_1$～$t_(11)$の順序でデータ`a`、`b` に対する
処理を行った場合、デッドロックとなるのはどの時点か。
ここで、DBMSは`READ`の直前に共有ロック、`UPDATE`の直前に占有ロックをかけ、
`ROLLBACK`又は`COMMIT`ですべてのロックを解除する。

#figure(
  table(
    columns: (2em,) + (6em,) * 3,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 11 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, $T_1$, $T_2$, $T_3$),
    $t_1$, `READ a`, [], [],
    $t_2$, [], `UPDATE b`, [],
    $t_3$, `READ b`, [], [],
    $t_4$, [], `ROLLBACK`, [],
    $t_5$, [], [], `READ b`,
    $t_6$, [], [], `UPDATE a`,
    $t_7$, `UPDATE b`, [], [],
    $t_8$, [], [], `UPDATE b`,
    $t_9$, `UPDATE a`, [], [],
    $t_10$, `COMMIT`, [], [],
    $t_11$, [], [], `COMMIT`,
  ),
)

#options[
  + $t_6$
  + $t_7$
  + $t_8$
  + $t_9$
]

== SQLの隔離性水準

#data((2023, 3), p: (168, 171))

次の(1)&(2)に該当するトランザクションの隔離性水準はどれか。
+ 対象の表のダーティリードは回避できる。
+ 一つのトランザクション中で、対象の表のある行を2回以上参照する場合、
  1回目の読込みの列値と2回目以降の読込みの列値が同じであることが保証されない。
#options[
  + `READ COMMITTED`
  + `READ UNCOMMITTED`
  + `REPEATABLE READ`
  + `SERIALIZABLE`
]
