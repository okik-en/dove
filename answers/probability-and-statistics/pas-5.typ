#import "../../typ/templates/report.typ": *
#import "../../typ/utils/replace.typ": *
#show: simple-report
#show: replace

#set page("a4")

#set list(indent: 2em, spacing: 1em)
#set terms(indent: 2em, spacing: 1em)
#set enum(indent: 2em, spacing: 1em, numbering: "(1)")
#set grid(gutter: 2em, align: top)
#show math.equation: it => math.display(it)

#let ans = box(text("解答", red, weight: "black", font: family.sans), stroke: 1pt + red, inset: 4pt, radius: 4pt)

#set document(title: "確率統計⑤")

#let Var = math.class("normal", "Var")
#let Cov = math.class("normal", "Cov")

#let Bin = math.class("normal", math.italic("Bin"))
#let Po = math.class("normal", math.italic("Po"))

#let options(body) = {
  set enum(
    numbering: n => text(
      weight: "bold",
      font: family.sans,
      numbering("ア", n),
    ),
    body-indent: 2em,
  )
  body
}

#context counter(heading).update(5 - 1)

= 確率分布とモーメント母関数

== ポアソン分布

命題「二項分布は、ポアソン分布で近似できる。
その一方で、正規分布も二項分布を近似できる」を考える。
この命題は正しいかどうか考察せよ。間違いであれば、その理由を指摘せよ。
もし、正しいならば、なぜ、同じ二項分布が$2$つの異なる分布、ポアソン分布と正規分布とで近似できるのか、
その理由を、できるだけ数式を用いて説明せよ。

#ans

この命題は正しい。
$Bin(n, p)$は$P(X = k) = binom(n, k) p^k (1 - p)^(n - k)$とかけて、$n p$および$n (1 - p)$が十分に大きいときはド・モアブル--ラプラスの定理から$N(n p, n p (1 - p))$に近似できる。
他方で$n$が十分に大きく$p$が十分に小さいときはポアソンの小数の法則から$binom(n, k) p^k (1 - p)^(n - k) -> e^(-lambda) lambda^k/k!$とみなせて、近似的にポアソン分布に従うものとみなせる。

== 指数分布とポアソン分布

ある銀行に$1$台のATMがあり、このATMの1人当たりの処理時間は平均$40$秒の指数分布に従う。
また、このATMを利用するために到着する利用者の数は$1$時間当たり平均$60$人のポアソン分布に従う。
このとき、利用者がATMに並んでから処理が終了するまでの時間の平均値はどれですか。
選択に際した、理由/計算考察も詳しく記述すること。

#options[
  + $60$秒
  + $75$秒
  + $90$秒
  + $105$秒
  + $120$秒
]

#ans

わからん…#emoji.face.cry

== 二項分布とポアソン分布

+ 打率が$3$割のバッターが$5$打席で、ヒットを少なくとも一本打つ確率を求めなさい。
+ 平均して$1$分間に$2$人が銀行窓口に並ぶとする。
  この窓口に$1$分間に$4$人以上並ぶ確率を求めなさい。

#ans

+ このバッターが$5$打席で打つヒットの本数を$X$とすれば、$X tilde.op Bin(5, 0.3)$であり
  $ P(X >= 1) = 1 - P(X = 0) = 1 - (0.7)^5 = 1 - 0.16807 = 0.83193 $
+ この窓口に$1$分間に並ぶ人数を$X$とすれば、$X tilde.op Po(2)$であり
  $
    P(X >= 4) & = 1 - P(0 <= X <= 3) = 1 - e^(-2) (1 + 2 + 2 + 4/3) = 1 - 19/3 e^(-2) \
              & approx 1 - 19/3 dot 18/133 = 57/399 approx 0.1429
  $

  ただし
  #{
    show math.frac: it => math.display(it, cramped: true)
    eqref(<e2>)[$
      e^2 = 1 + frac(2, (1 - 1) + frac(1, 3 + frac(1, 5 + frac(1, 7 + frac(1, 9 + dots.down))))) approx 1 + frac(2, 0 + frac(1, 3 + frac(1, 5 + frac(1, 7 + 0)))) = 18/399
    $]
  }
  を用いた。

== ポアソン分布

確率値の回答では、小数点下$4$桁までの値で答えること。
+ ある町の$1$日の交通事故の件数が、平均$3$件のポアソン分布に従うとする。
  この町におけるある日の事故件数が、$2$件以上である確率を求めよ。
+ 確率変数$X$がポアソン分布に従い、$P(X = 3) = 5P(X = 5)$なる関係を満たす。この時の$P(X <= 3)$を計算せよ。

#ans

+ $X tilde.op Po(3)$より
  $
    P(X >= 2) & = 1 - P(0 <= X <= 1) = 1 - e^(-3) (1 + 3) = 1 - 4/e^3 \
              & approx 1 - 4 dot 221/4439 = 3555/4439 approx 0.8009
  $

  ただし
  #{
    show math.frac: it => math.display(it, cramped: true)
    eqref(<e3>)[$
      e^3 approx 1 + frac(6, (2 - 3) + frac(9, 6 + frac(9, 10 + frac(9, 14 + frac(9, 18 + 0))))) = 4439/221
    $]
  }
  を用いた。
+ $P(X = 3) = e^(-lambda) lambda^3/3! = e^(-lambda) lambda^3/6$および$5 P(X = 5) = 5 e^(-lambda) lambda^5/5! = e^(-lambda) lambda^3/6 (lambda/2)^2$より、$lambda = 2$である。ゆえに$X tilde.op Po(2)$より
  $ P(X <= 3) = e^(-2) (1 + 2 + 2 + 4/3) approx 18/133 dot 19/3 = 342/399 approx 0.8751 $

  ただし#[@e2]を用いた。

== ポアソン分布の例

不良品率が$1%$である製品を、$200$個取り出し袋に詰める時、次を求めよ。
+ 袋の中の不良品の数$X$の確率分布
+ 不良品が全く入っていない確率
+ 不良品が$3$個以上入っている確率

(2)と(3)の答えは、できるだけ適当な小数点までの近似で、最終計算すること。

#ans

+ $P(X = k) = binom(n, k) (1/100)^k (99/100)^(200 - k) approx e^(-2) 2^k/k!$
+ $P(X = 0) approx e^(-2) approx 18/133 approx 0.1353$
+ $P(X >= 3) = 1 - P(0 <= X <= 2) = 1 - e^(-2) (1 + 2 + 2) approx 1 - 5 dot 18/133 = 43/133 approx 0.3233$

== 二項分布とその近似

確率値の回答では、小数点下$4$桁までの値で答えること。
計算考察過程も詳しく回答すること。
+ サイコロを$240$回投げた時、$6$の目が$38$〜$45$回出る確率を求めなさい。
+ 不良品率が$0.1%$である製品を$500$個取り出した時、不良品が$3$個以上入っている確率を求めなさい。

#ans

+ $n = 240$および$p = 1/6$とおくと、$6$の目が出る回数$X$は二項分布$Bin(n, p)$に従う。
  $n p = 40$と$n (1 - p) = 200$のいずれも十分に大きい（$5$以上）ため、ド・モアブル--ラプラスの定理から$X$は近似的に正規分布$N(n p, n p (1 - p)) = N(40, 100/3)$に従うものとみなせて
  $
    P(38 <= X <= 45) &approx P(37.5 <= X <= 45.5) = P(frac(37.5 - 40, frac(10, sqrt(3), style: "skewed")) <= Z <= frac(45.5 - 40, frac(10, sqrt(3), style: "skewed"))) \
    &= P(-0.25 sqrt(3) <= Z <= 0.55 sqrt(3)) approx P(-0.43 <= Z <= 0.95) \
    &= 0.8289 - 0.3336 = 0.4953
  $
+ $n = 500$および$p = 1/1000$とおくと、不良品の個数$X$は二項分布$Bin(n, p)$に従う。
  $n$は十分に大きく$P$は十分に小さいため、$X$は近似的にポアソン分布$Po(lambda)$に従うものとみなせて、$lambda = n p = 1/2$に留意して
  $
    P(X >= 3) & = 1 - P(0 <= X <= 2) = 1 - e^(-1/2) (1 + 1/2 + 1/8) = 1 - e^(-1/2) 13/8 \
    & approx 1 - frac(12 dot 2^2 - 6 dot 2 + 1, 12 dot 2^2 + 6 dot 2 + 1) dot 13/8 = 1 - 37/61 dot 13/8 = 7/488 approx 0.0143
  $

  ただし
  #{
    show math.frac: it => math.display(it, cramped: true)
    eqref(<en>)[$
      root(n, e) approx 1 + frac(2, (2n - 1) + frac(1, 6n + 0)) = frac(12 n^2 + 6 n + 1, 12 n^2 - 6 n + 1)
    $]
  }
  を用いた。

== 二項分布とポアソン分布

「表が出る確率が$p$（$0 < p < 1$）、裏が出る確率が$(1 - p)$のコインを独立に$N$回（$N > 1$）投げ、
得られる表と裏の列」を考える。
以下の問に、式の導出も含めて答えよ。

+ $N = 5$とする。列 「表表裏表裏」 が得られる確率を求めよ。
+ 最初の$t$個（$0 <= t <= N$） がすべて表になる確率を求めよ。
+ 初めて裏がでるまでの、表の数を$m$とする。
  ただし、裏がひとつもない列では$m = N$とする（$0 <= m <= N$）。
  この$m$の期待値を求めよ。
+ 表を$n$個（$0 <= n <= N$）、裏を（$N - n$）個持つ列が得られる確率$P(n \& N, p)$を求めよ。
+ 上記(4)において、$n$の期待値を求めよ。
+ $n$と$lambda = N p$を固定し、$N -> infinity$の極限をとると、
  (4)の確率分布$P(n \& N, p)$はポアソン分布$P(n; lambda)$に近づくことを証明せよ。
  必要であれば、等式$lim_(N -> infinity) (1 + x/N)^N = e^x$を使って良い。

#ans

+ $p dot p dot (1 - p) dot p dot (1 - p) = p^3 (1 - p)^2$
+ $p^t$
+ $E[m] = sum_(m = 0)^(N - 1) p^m (1 - p) dot m + p^N dot m = frac(p, 1 - p) (1 - p^N)$
+ $P(n \& N, p) = binom(N, n) p^n (1 - p)^(N - n)$
+ $E[n] = sum_(n = 0)^N n P(n \& N, p) = N p$
+ $lambda = N p$に留意すれば以下より従う：
  $
      & lim_(N -> infinity) binom(N, n) p^n (1 - p)^(N - n) \
    = & lim_(N -> infinity) frac(N!, n! (N - n)!) p^n (1 - p)^(N - n) \
    = & lim_(N -> infinity) 1/n! N (N - 1) (N - 2) dots.c (N - n + 1) (lambda/N)^n (1 - lambda/N)^(N - n) \
    = & lim_(N -> infinity) lambda^n/n! (1 - 1/N) (1 - 2/N) dots.c (1 - (n - 1)/N) (1 - lambda/N)^(-n) (1 + (-lambda)/N)^N \
    = & lambda^n/n! e^(-lambda)
  $
