#import "../../utils.typ": *
#import "@preview/cetz:0.5.2"

= トランザクション

== トランザクションとは

#data(((2022, 2), (2023, 3), (2024, 3), (2025, 3)), p: (128, 130))

トランザクションとは、データベースに対する#ana(1)レベルでの一つの#ana(2)な作用をいう。
通常、#ana(3)レベルでのデータベースに対する#ana(2)な作用は、SQLで言えば、
質問のための`SELECT`文や更新のための`INSERT`文や`DELETE`文などであるが、
#ana(1)レベルでは、それらひとつひとつは、一般には意味を持たないことに注意する。
トランザクションとう概念がデータベースに導入されてはじめて、
データベースの#ana(4)という概念が明確になった。
それにより、#ana(5)回復の全貌が明らかになった。
さらに、組織体の#ana(6)資源としてのデータベースに同時に多数のユーザーがアクセスし、
整合の取れた作業ができることを約束する#ana(7)制御の概念が明らかとなった。

== PC--トランザクション

#data(((2024, 3), (2025, 3)))

パーソナルコンピュータ（パソコン）では、トランズアクションの概念をあまり聞きません。
理由を説明しなさい。

== データベースの一貫性

#data((2023, 4), p: (130, 133))

次の図は、データベースの何を説明したものか、具体的に説明しなさい。

#figure(
  image("2023-4-03-1.png", height: 12em),
)

== ACID特性

#data((2022, 3), p: ((130, 134), (137, 138)))

トランザクションのACID特性に関する記述のうち、適切なものはどれか。
#options[
  + コミット後にシステム障害が発生した場合、その内容は変更前の状態に戻される。
  + トランザクションが同時に実行されても、互いに干渉しない。
  + トランザクションの実行の結果、データベースの整合性が崩れることも許容する。
  + トランザクションの途中でシステム障害が発生しても、障害発生時までの変更内容は保存される。
]

== 状態遷移

#data(((2022, 2), (2022, 3), (2023, 2), (2024, 3), (2025, 3)), p: ((130, 134), (137, 138)))

+ 「トランザクション」が満たすべき$4$つの性質（ACID特性）を説明せよ。
+ 図はトランザクションの状態遷移である。
  #figure(
    cetz.canvas({
      import cetz.draw: *
      set-style(
        circle: (radius: .7),
        content: (align: center, wrap: it => align(center, text(size: 8pt, it))),
        line: (mark: (end: ">", fill: black, scale: 0.5)),
      )

      content((-2, 2), [トランザクションの \ 開始], name: "S")
      circle((0, 1), name: "P")
      content((), [実行中])
      circle((3, 2), name: "Q")
      content((), [コミット \ 待ち])
      circle((3, 0), name: "R")
      content((), [失敗])
      circle((6, 2), name: "C")
      content((), _opt_[C])
      circle((6, 0), name: "D")
      content((), _opt_[D])

      line("S.south", "P")
      line("P", "Q.west", name: "PQ")
      content(
        ("PQ.start", 50%, "PQ.end"),
        angle: "PQ.end",
        anchor: "south",
        padding: .2,
        [プログラム \ 実行終了],
      )
      line("P", "R.west", name: "PR")
      content(
        ("PR.start", 50%, "PR.end"),
        angle: "PR.end",
        anchor: "north",
        padding: .2,
        [障害発生],
      )
      line("Q", "C", name: "QC")
      content(
        ("QC.start", 50%, "QC.end"),
        angle: "QC.end",
        anchor: "south",
        padding: .2,
        _opt_[A],
      )
      line("R", "D", name: "RD")
      content(
        ("RD.start", 50%, "RD.end"),
        angle: "RD.end",
        anchor: "north",
        padding: .2,
        _opt_[B],
      )
    }),
  )
  + 空欄#_opt_[A]、#_opt_[B]、#_opt_[C]、#_opt_[D]に入れるべき内容は何か？
  + そして、全体の意味を説明せよ。
+ トランザクションが自主的に`abort`命令を発行するのは、どういう場合か？
+ `EXEX SQL COMMIT`が実行されたのであれば、コミット待ち状態ではなく、
  なぜ直ちに#_opt_[C]状態に遷移しないのか、を考える。
  その理由は#ana("E/ここは文章を与えること")であるからである。
  この状態では、システムがクラッシュしてしまうと、主記憶は#ana("F")だから実行結果が霧散してしまう。

== 障害時回復

#data(((2022, 4), (2023, 2), (2024, 3), (2025, 3)), p: ((130, 134), (137, 138)))

「トランザクション」が満たすべき$4$つの性質（ACID特性）に関して
+ $4$つの性質の英単語と日本語訳を与えなさい（A、C、I、Dはそれぞれ何か？）
+ COMMIT処理は、どの特性と関係があるか？
+ ACID 特性の中で、表裏一体の関係である$2$つは何か？
+ 障害時回復は、どの特性と関係があるか？
+ データベースの特性を損なう障害を$3$つ列挙し、それぞれを説明しなさい。

== ロールバック

#data((2022, 3), p: (138, 139))

トランザクション処理プログラムが、データベース更新の途中で異常終了した場合、
ロールバック処理によってデータベースを復元する。このとき使用する情報はどれか。
#options[
  + 最新のスナップショット情報
  + 最新のバックアップファイル情報
  + ログファイルの更新後情報
  + ログファイルの更新前情報
]

== ログ

#data((2023, 3), p: (138, 139))

DBMS が取得するログに関する記述として，適切なものはどれか。
#options[
  + トランザクションの取消しに備えて，データベースの更新されたページに対する更新後情報を取得する。
  + 媒体障害からの復旧に備えて，データベースの更新されたページに対する更新前情報を取得する。
  + ロールバック後のトランザクション再実行に備えて、
    データベースの更新されたページに対する更新後情報を取得する。
  + ロールフォワードに備えて，データベースの更新されたページに対する更新後情報を取得する。
]

== ログとディスク

#data(((2024, 3), (2025, 4)))

ログは障害時回復の手がかりを与えるものなので、障害派生した#ana(1)のメディアに記録しなければならない。
通常はディスクを二重化して#ana(2)を実現してそこに記憶する。
RAID-1〔日本語で#ana(3)〕は、仮にディスクMTBF〔日本語で#ana(4)〕を#ana(5)時間とすれば、
お互いのディスクは#ana(6)に故障するとして、両ディスクが同時にダウンする$2$重故障の発生は
#ana(7)年に一度だろうと計算される

== コミット処理

#data(((2022, 2), (2022, 3)), p: 139)

システム障害発生時には、データベースの整合性を保ち、かつ、最新のデータベース状態に復旧する必要がある。
このために、DBMSがトランザクションのコミット処理完了とみなすタイミングとして、適切なものはどれか。
#options[
  + アプリケーションの更新命令完了時点
  + チェックポイント処理完了時点
  + ログバッファへのコミット情報書込み完了時点
  + ログファイルへのコミット情報書出し完了時点
]

== RAIDの種類

#data(((2023, 4), (2025, 4)), p: (140, 141))

RAIDの種類a、b、cに対応する組み合わせとして適切なものはどれか。

#figure(
  table(
    columns: (12em,) + (5em,) * 3,
    [RAIDの種類], [a], [b], [c],
    [ストライピングの単位], [ビット], [ブロック], [ブロック],
    [冗長ディスクの構成], [固定], [固定], [分散],
  ),
)

#figure(
  table(
    columns: (3em,) + (5em,) * 3,
    [], [a], [b], [c],
    text(font: family.sans, weight: "bold")[ア], [RAID3], [RAID4], [RAID5],
    text(font: family.sans, weight: "bold")[イ], [RAID3], [RAID5], [RAID4],
    text(font: family.sans, weight: "bold")[ウ], [RAID4], [RAID3], [RAID5],
    text(font: family.sans, weight: "bold")[エ], [RAID5], [RAID5], [RAID3],
  ),
)

== RAIDの特性

#data(((2023, 4), (2024, 3), (2024, 4)), p: (140, 141))

次の特性を満たすRAIDをRAID-1〜RAID-5から全て選びなさい。
該当するものは$1$つとは限らないことに注意する。
+ 実現するために必要な記憶容量が$2$倍なる方式
+ 誤り訂正を構成する分だけ、余分に記憶容量が必要になる方式
+ 誤り検出符号の分だけ、余分に記憶容量が必要になる方式
+ 参加するすべてのモジュールの一体動作（同時に書き込みをする）を必要とする方式
+ 参加するそれぞれのモジュールが独立して読み書きできる方式

== RAIDと誤り訂正

#data(((2024, 4), (2025, 4)))

+ RAIDの省略形ではない原英語とその和訳を与えなさい。
+ RAIDに使われている誤り検出符号とは何か、
  + この符号名と原理を説明しなさい。
  + この誤り検出符号は、訂正機能までは有していないことも説明しなさい。
+ RAID-0/ゼロも含めて、RAID-5 までの六つを図を用いて説明せよ、
  特に、RAID-0 vs RAID-1の違い、他のRAID群の間の関係なども論じること。

== WALプロトコル

#data((2022, 3), p: (142, 144))

更新前情報と更新後情報をログとして利用するDBMSにおいて、ログを先に書き出すWAL（Write Ahead Log）
プロトコルに従うとして、処理①～⑥を正しい順番に並べたものはどれか。
#enum(
  numbering: "①",
  [`begin transaction`レコードを書きだす。],
  [データベースを更新する],
  [ログに更新前レコードを書き出す。],
  [ログに更新後レコードを書き出す。],
  [`commit`レコードを書き出す。],
  [`end transaction`レコードを書き出す。],
)
#options[
  + ① $->$ ② $->$ ③ $->$ ④ $->$ ⑤ $->$ ⑥
  + ① $->$ ③ $->$ ② $->$ ④ $->$ ⑥ $->$ ⑤
  + ① $->$ ③ $->$ ② $->$ ⑤ $->$ ④ $->$ ⑥
  + ① $->$ ③ $->$ ④ $->$ ② $->$ ⑤ $->$ ⑥
]

== チェックポイント法

#data(((2023, 4), (2024, 3), (2025, 4)), p: (144, 146))

チェックポイント法による障害時回復のシナリオを↓図で示した通りとする
（$T_1$〜$T_7$は、トランザクション）。
ここに記号"・"は`BEGIN TRANSACTION`を、矢印が`COMMIT`を表すとする。
また、$T_3$と$T_5$は読込みのみ（read-only）のトランザクションとする
（他のトランザクションは、読込も書込みも行う）。
この時、$T_1$から$T_7$の各トランザクションについて、障害発生後に修復が終わり、DBMSを再起動する際に、
+ 何もしなくて良いトランザクション
+ UNDO するトランザクション
+ REDO するトランザクション
に分類しなさい。それぞれに理由も与えること。

#figure(
  cetz.canvas({
    import cetz.draw: *
    set-style(content: (padding: .1))

    line((0, 8), (12, 8), mark: (end: ">", fill: black, scale: .5))
    content((), anchor: "west", [時間])
    line((4, 0), (4, 8))
    content((), anchor: "north-west", $t_c$)
    content(
      (),
      anchor: "south",
      wrap: it => align(center, text(size: 8pt, it)),
      [システム障害発生直前の \ チェックポイント],
    )
    line((10, 0), (10, 8))
    content((), anchor: "north-west", $t_f$)
    content(
      (),
      anchor: "south",
      wrap: it => align(center, text(size: 8pt, it)),
      [システム障害発生],
    )

    line((0, 7), (3, 7), stroke: blue, mark: (start: "circle", end: ">", fill: blue, scale: .8), name: "T1")
    content(("T1.start", 50%, "T1.end"), anchor: "south", $T_1$)
    line((5, 6), (8, 6), stroke: blue, mark: (start: "circle", end: ">", fill: blue, scale: .8), name: "T2")
    content(("T2.start", 50%, "T2.end"), anchor: "south", $T_2$)
    line((2, 5), (10, 5), stroke: blue, mark: (start: "circle", fill: blue, scale: .8), name: "T3")
    content(("T3.start", 50%, "T3.end"), anchor: "south", $T_3$)
    line((3, 4), (9, 4), stroke: blue, mark: (start: "circle", end: ">", fill: blue, scale: .8), name: "T4")
    content(("T4.start", 50%, "T4.end"), anchor: "south", $T_4$)
    line((6, 3), (10, 3), stroke: blue, mark: (start: "circle", fill: blue, scale: .8), name: "T5")
    content(("T5.start", 50%, "T5.end"), anchor: "south", $T_5$)
    line((2, 2), (10, 2), stroke: blue, mark: (start: "circle", fill: blue, scale: .8), name: "T6")
    content(("T6.start", 50%, "T6.end"), anchor: "south", $T_6$)
    line((6, 1), (10, 1), stroke: blue, mark: (start: "circle", fill: blue, scale: .8), name: "T7")
    content(("T7.start", 50%, "T7.end"), anchor: "south", $T_7$)
  }),
)
