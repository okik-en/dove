#import "/style/utils.typ": *

== 同時実行制御の必要性

#data(((2023, 3), (2024, 3)), p: (151, 153))

下の図はどのような異常を引き起こすスケジュールの事例であるか、その異常名とその原因の解析を、
図に従って説明しなさい。

#figure(
  caption: [$A$は夫婦共通の口座Aの残高を表す。],
  table(
    columns: (2em,) + (12em,) * 2,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 6 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, [$T_1$ （A夫）], [$T_2$ （A子）]),
    $t_1$, [read($A$)], [],
    $t_2$, [], [read($A$)],
    $t_3$, [write($A colon.eq A - 30$)], [],
    $t_4$, [], [write($A colon.eq A - 20$)],
    $t_5$, [COMMIT], [],
    $t_6$, [], [COMMIT],
  ),
)

#ans[
  いま仮に口座Aの残高の初期値は100万円だったとすれば、時刻$t_2$では、まだ$T_1$による残高更新がなされていないので、$T_2$が読んだ残高値も、$T_1$が読んだそれと同じく、100万円である。
  時刻$t_3$で残高が70万円に更新されるが、時刻$t_4$でそれは$T_2$により上書きされて80万円になる（遺失更新）。
  そして$T_1$と$T_2$のCOMMIT処理が行われて実行が終了する。
  つまり、A夫婦は計50万円も手にしたのに、たった20万円しか引かれておらず、これを異質更新異常と呼ぶ。
]

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
    $t_1$, [read($A$)], [],
    $t_2$, [write($A colon.eq A + 10$)], [],
    $t_3$, [], [read($A$)],
    $t_4$, [], [write($A colon.eq A - 10$)],
    $t_5$, [], [COMMIT],
    $t_6$, [ROLLBACK], [],
  ),
)

#ans[
  $T_1$は銀行口座に10万円を振り込み、$T_2$はまだコミットしていない$T_1$の値を読み（汚読）、その間に$T_1$のROLLBACK処理が行われアボートされる。
  $T_1$はアボートされたから親元の10万円は振り込まれないで済んだが、$T_2$はその間にコミットしているから、学生はその10万円をしっかり手にしており、これを汚読異状と呼ぶ。
]

== 同時実行制御の必要性

#data((2023, 3), p: (166, 167))

下の図はどのような障害を説明したものか、その障害名と、原因解析を図に従って説明しなさい。

#figure(
  table(
    stroke: none,
    columns: 2,
    $T_1$, $T_2$,
    ```
    begin
      read(x)
      read(y)
      write(x)
    end
    ```,
    ```
    begin
      read(y)
      read(x)
      write(y)
    end
    ```,
  ),
)

#figure(
  table(
    columns: (2em,) + (6em,) * 2,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 4 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, $T_1$, $T_2$),
    $t_1$, [lock($x$)], [],
    $t_2$, [], [lock($y$)],
    $t_3$, [read($x$)], [],
    $t_4$, [], [read($y$)],
  ),
)

#ans[
  いま時刻$t_1$に$T_1$がlock($x$)を実行し、次の時刻$t_2$に$T_2$がlock($y$)を実行したとする。
  続いて$T_1$、$T_2$が各々第1ステップread($x$)とread($y$)を実行し、続けて$T_1$が第2ステップread($y$)の実行のためにlock($y$)を要求すると、$T_2$がロックしている$y$はまだアンロックされていないのでそれは待ちの状態に入る。
  一方、$T_2$においても同様で、第2ステップread($x$)の実行のためにlock($x$)を要求して、待ちの状態に入る。
  しかし、$T_2$が$y$をアンロックするには$T_1$がロックしている$x$がアンロックされることが必要で、つまり、$T_1$と$T_2$はお互いに相手の処理を待つという永久待ちの状態、すなわち、デッドロック ＜ #sym.dagger 死の抱擁 #sym.dagger ＞ に陥ってしまう。
]

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
      table.cell(colspan: 2, _opt_[ア]),
      table.cell(colspan: 2, _opt_(font: family.sans, weight: "bold")[イ]),
      table.cell(colspan: 2, _opt_(font: family.sans, weight: "bold")[ウ]),
      table.cell(colspan: 2, _opt_(font: family.sans, weight: "bold")[エ]),
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

#ans[
  #_opt_[エ]。2PL、すなわち以下を満たさなければならない。
  + トランザクションは、データ項目$x$を読むにしろ書くにしろ、それを行う前にまず$x$をロックしなければならない（#_opt_[ア]が違反）。
  + もしロックしようとしたデータ項目が他のトランザクションによりロックされているならば、それをロックすることはできない。
  + トランザクションは、データ項目のロックが不必要となったら、アンロックする。
    しかし、トランザクションは、読みや書きのために必要な全てのロックが完了する前に、それらをアンロックすることはしない（#_opt_[イ]、#_opt_[ウ]が違反）。
]

== 2相ロッキングプロトコル

#data((2023, 3), p: (163, 165))

2相ロッキングプロトコルに従ってロックを獲得するトランザクション$A$、$B$を
図のように同時実行した場合に、デッドロックが発生しないデータ処理順序はどれか。
ここで、readとupdateの位置は，アプリケーションプログラムでの命令発行時点を表す。
また、データ$W$へのreadは共有ロックを要求し、
データ$X$、$Y$、$Z$へのupdateは各データへの専有ロックを要求する。

#figure(
  table(
    columns: (2em,) + (6em,) * 2,
    align: (x, y) => if x == 0 or y == 0 { center } else { left },
    stroke: (x, y) => if y == 0 { 1pt } else if y == 8 { (top: none, rest: 1pt) } else { (x: 1pt) },
    table.header($t$, $A$, $B$),
    $t_1$, [read($W$)], [],
    $t_2$, [], ana(1),
    $t_3$, [update($X$)], [],
    $t_4$, [], ana(2),
    $t_5$, [update($Y$)], [],
    $t_6$, [], ana(3),
    $t_7$, [update($Z$)], [],
    $t_8$, [], ana(4),
  ),
)

#figure(
  table(
    align: center,
    columns: (3em,) + (6em,) * 4,
    [], ana(1), ana(2), ana(3), ana(4),
    _opt_[ア], [read($W$)], [update($Y$)], [update($X$)], [update($Z$)],
    _opt_[イ], [read($W$)], [update($Y$)], [update($Z$)], [update($X$)],
    _opt_[ウ], [update($X$)], [read($W$)], [update($Y$)], [update($Z$)],
    _opt_[エ], [update($Y$)], [update($Z$)], [update($X$)], [read($W$)],
  ),
)

#ans[
  #_opt_[ウ]。
]

== 専有ロックと共有ロック

#data((2022, 3), p: 165)

ロックの両立性に関する記述のうち、適切なものはどれか。
#options(a: 2)[
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
#options(a: 2)[
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
  table(
    columns: 2,
    stroke: none,
    $T_1$, $T_2$,
    ```
    begin
      read(x)
      write(x)
    end
    ```,
    ```
    begin
      read(y)
      read(x)
      write(y)
    end
    ```,
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

#ans[
  + #table(
      columns: 3,
      stroke: none,
      align: center + horizon,
      $S_1$, $S_2$, $S_3$,
      table(
        columns: (2em,) + (5em,) * 2,
        align: (x, y) => if x == 0 or y == 0 { center } else { left },
        stroke: (x, y) => if y == 0 { 1pt } else if y == 5 { (top: none, rest: 1pt) } else { (x: 1pt) },
        table.header($t$, $T_1$, $T_2$),
        $t_1$, [read($x$)], [],
        $t_2$, [], [read($y$)],
        $t_3$, [write($x$)], [],
        $t_4$, [], [read($x$)],
        $t_5$, [], [write($y$)],
      ),
      table(
        columns: (2em,) + (5em,) * 2,
        align: (x, y) => if x == 0 or y == 0 { center } else { left },
        stroke: (x, y) => if y == 0 { 1pt } else if y == 5 { (top: none, rest: 1pt) } else { (x: 1pt) },
        table.header($t$, $T_1$, $T_2$),
        $t_1$, [read($x$)], [],
        $t_2$, [], [read($y$)],
        $t_3$, [], [read($x$)],
        $t_4$, [write($x$)], [],
        $t_5$, [], [write($y$)],
      ),
      table(
        columns: (2em,) + (5em,) * 2,
        align: (x, y) => if x == 0 or y == 0 { center } else { left },
        stroke: (x, y) => if y == 0 { 1pt } else if y == 5 { (top: none, rest: 1pt) } else { (x: 1pt) },
        table.header($t$, $T_1$, $T_2$),
        $t_1$, [read($x$)], [],
        $t_2$, [], [read($y$)],
        $t_3$, [], [read($x$)],
        $t_4$, [], [write($y$)],
        $t_5$, [write($x$)], [],
      ),
    )
  + $S_1$。$T_2$におけるread($x$)より前に$x$がアンロックされる必要があるため。
  + #table(
      columns: (2em,) + (6em,) * 2,
      align: (x, y) => if x == 0 or y == 0 { center } else { left },
      stroke: (x, y) => if y == 0 { 1pt } else if y == 11 { (top: none, rest: 1pt) } else { (x: 1pt) },
      table.header($t$, $T_1$, $T_2$),
      $t_1$, [lock($x$)], [],
      $t_2$, [read($x$)], [],
      $t_3$, [], [lock($y$)],
      $t_4$, [], [read($y$)],
      $t_5$, [write($x$)], [],
      $t_6$, [unlock($x$)], [],
      $t_7$, [], [lock($x$)],
      $t_8$, [], [read($x$)],
      $t_9$, [], [write($y$)],
      $t_(10)$, [], [unlock($x$)],
      $t_(11)$, [], [unlock($y$)],
    )
  + $T_1 --> T_2$
  + #table(
      columns: (2em,) + (6em,) * 2,
      align: (x, y) => if x == 0 or y == 0 { center } else { left },
      stroke: (x, y) => if y == 0 { 1pt } else if y == 11 { (top: none, rest: 1pt) } else { (x: 1pt) },
      table.header($t$, $T_1$, $T_2$),
      $t_1$, [lock($x$)], [],
      $t_2$, [read($x$)], [],
      $t_3$, [write($x$)], [],
      $t_4$, [unlock($x$)], [],
      $t_5$, [], [lock($y$)],
      $t_6$, [], [read($y$)],
      $t_7$, [], [lock($x$)],
      $t_8$, [], [read($x$)],
      $t_9$, [], [write($y$)],
      $t_(10)$, [], [unlock($x$)],
      $t_(11)$, [], [unlock($y$)],
    )
]

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
    $t_1$, [read($a$)], [], [],
    $t_2$, [], [update($b$)], [],
    $t_3$, [read($b$)], [], [],
    $t_4$, [], [rollback()], [],
    $t_5$, [], [], [read($b$)],
    $t_6$, [], [], [update($a$)],
    $t_7$, [update($b$)], [], [],
    $t_8$, [], [], [update($b$)],
    $t_9$, [update($a$)], [], [],
    $t_10$, [COMMIT], [], [],
    $t_11$, [], [], [COMMIT],
  ),
)

#options(a: 2)[
  + $t_6$
  + $t_7$
  + $t_8$
  + $t_9$
]

#ans[
  以下のようになる。
  ただし$S(circle.filled.tiny)$は共有ロック、$E(circle.filled.tiny)$は専有ロック、$W(circle.filled.tiny)$は待ちを表す。
  #figure(
    table(
      columns: (2em,) + (6em,) * 3,
      align: (x, y) => if x == 0 or y == 0 { center } else { left },
      stroke: (x, y) => if y == 0 { 1pt } else if y == 7 { (top: none, rest: 1pt) } else { (x: 1pt) },
      table.header($t$, $T_1$, $T_2$, $T_3$),
      $t_1$, $S(a)$, [], [],
      $t_2$, $S(a)$, $E(b)$, [],
      $t_3$, $S(a), W(b)$, $E(b)$, [],
      $t_4$, $S(a, b)$, [], [],
      $t_5$, $S(a, b)$, [], $S(b)$,
      $t_6$, $S(a, b)$, [], $S(b), W(a)$,
      $t_7$, $S(a), W(b)$, [], $S(b), W(a)$,
    ),
  )
]

== 汚読

#data(pretest)

汚読が発生する状況を自分で作り、なぜ問題かを説明せよ（120～160字）。

#ans[
  トランザクション$T_1$が口座残高を100万円から80万円に更新したが、#underline[まだコミットしていない]状態で、$T_2$がその残高80万円を#underline[読み取った]とする。
  その後、$T_1$がエラーで#underline[ロールバック]されると残高は100万円に戻る。
  このとき$T_2$は存在しない更新結果を基に処理したことになり、データの整合性が損なわれる。
  これを汚読という。
]

== SQLの隔離性水準

#data((2023, 3), p: (168, 171))

次の(1)&(2)に該当するトランザクションの隔離性水準はどれか。
+ 対象の表のダーティリードは回避できる。
+ 一つのトランザクション中で、対象の表のある行を2回以上参照する場合、
  1回目の読込みの列値と2回目以降の読込みの列値が同じであることが保証されない。
#options(a: 2)[
  + `READ COMMITTED`
  + `READ UNCOMMITTED`
  + `REPEATABLE READ`
  + `SERIALIZABLE`
]

#ans[
  以下を参照のこと。
  違反形態を許す場合は#{ emoji.circle.stroked }、違反形態を許さない場合は#{ emoji.crossmark }で表す。
  #figure(
    table(
      columns: (10em,) + (6em,) * 3,
      align: center + horizon,
      [隔離性水準], [汚読], [反復不可能 \ な読み], [幽霊],
      `READ_UNCOMMITED`, emoji.circle.stroked, emoji.circle.stroked, emoji.circle.stroked,
      `READ_COMMITED`, emoji.crossmark, emoji.circle.stroked, emoji.circle.stroked,
      `REPEATABLE_READ`, emoji.crossmark, emoji.crossmark, emoji.circle.stroked,
      `SERIALIZABLE`, emoji.crossmark, emoji.crossmark, emoji.crossmark,
    ),
  )
]
