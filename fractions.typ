#import "typ/templates/okiken.typ": *
#import "typ/utils/replace.typ": *
#show: okiken-style
#show: replace

#set page("a4")

#set list(indent: 2em, spacing: 1em)
#set terms(indent: 2em, spacing: 1em)
#set enum(indent: 2em, numbering: "(1-a)", spacing: 1em)
#set grid(gutter: 2em, align: top)
#show math.equation: it => math.display(it)
#set math.accent(size: 111%)

#set document(title: "連分数展開")

#title()

= 平方根の近似

$N in NN without {n^2 mid(|) n in NN}$について、$sqrt(N)$の近似値を得たい。

== 簡単な展開

いま$tilde(N) = floor(sqrt(N))$は既知であるとすれば
$
  bold(sqrt(N) + tilde(N)) & = 2 tilde(N) + (sqrt(N) - tilde(N)) \
                           & = 2 tilde(N) + frac(N - tilde(N)^2, bold(sqrt(N) + tilde(N)))
$
となり、同じ項$sqrt(N) + tilde(N)$が繰り返される。

次の漸化式
$
  a_(n + 1) = 2 tilde(N) + frac(N - tilde(N)^2, a_n) wide "for" n in NN
$
を満たす数列$(a_n)$を考えよう。$a_0 > 1$のとき$forall n in NN : a_n > 1$であり

$
  abs(a_(n + 1) - (sqrt(N) + tilde(N))) & = abs(frac(N - tilde(N)^2, a_n) - (sqrt(N) - tilde(N))) \
                                        & = frac(sqrt(N) - tilde(N), a_n) abs((sqrt(N) + tilde(N)) - a_n) \
                                        & lt.double abs(a_n - (sqrt(N) + tilde(N)))
$
がわかるから、$(a_n)$は$n -> infinity$で$sqrt(N) + tilde(N)$に収束する。

とくに$a_n = b_n / c_n$、ただし$b_n, c_n in NN$とおけば
$
  b_(n + 1) / c_(n + 1) = 2 tilde(N) + (N - tilde(N)^2) c_n / b_n = frac((2 tilde(N)) b_n + (N - tilde(N)^2) c_n, b_n)
$
であり、これは線形写像として捉えることで
$
  vec(b_n, c_n) = mat(2 tilde(N), N - tilde(N)^2; 1, 0) vec(b_(n - 1), c_(n - 1))
$
とかけて、例えば$a_0 = 2 tilde(N)$とおけばそれなりの精度の近似値が得られるだろう。

#pagebreak()

== 正則連分数展開

あるいは以下のアルゴリズムで*正則な*連分数に展開できる。

/ 基底: $x_0 = sqrt(N)$とおく。
/ 帰納: $n_k = floor(x_k)$により$x_k = n_k + (x_k - n_k) = n_k + frac(bold(1), (frac(x_k + n_k, x_k^2 - n_k^2))) = n_k + bold(1) / x_(k + 1)$とかける。

  すなわち$x_(k + 1) = frac(x_k + n_k, x_k^2 - n_k^2)$とおく。

ここで$r in NN$について$0 <= (x_r - n_r) < 1$であることに注意すれば、これを$0$あるいは$1$とおいて挟むことで、帰納的に$x_0 = sqrt(N)$の近似値が正則連分数の形で求まる。

とくに$n_(r + 1) = floor(x_(r + 1))$が大きいとき、$1 / x_(r + 1)$は小さくなるため、これを$0$とおいて$x_0$を求めた値$[n_0; n_1, n_2, dots, n_r]$は真の値に近づく。

== ニュートン法

ニュートン法は、$f(x) = 0$の根$x = a$の付近で、次の漸化式
$ a_(n + 1) = a_n - frac(f(a_n), f'(a_n)) $
を用いて近似を行う方法である。

例えば$f(x) = x^2 - N$とおくと、$f'(x) = 2x$であるから、$sqrt(N)$の近傍で
$ a_(n + 1) = a_n - frac(a_n^2 - N, 2 a_n) = 1/2 (a_n + N / a_n) $
を繰り返し適用することで、$a_n$は$sqrt(N)$に収束する。

あるいは$a_n = b_n/c_n$、ただし$b_n, c_n in NN$とおけば
$ b_(n + 1)/c_(n + 1) = 1/2 (b_n/c_n + N (c_n/b_n)) = frac(b_n^2 + N c_n^2, 2 b_n c_n) $
である。

== エイトケンの$Delta^2$加速法

$ a_(n + 1) = (N/a_n) frac(3 a_n + (N/a_n), a_n + 3(N/a_n)) $
を用いることもできる。あるいは$a_n = b_n/c_n$、ただし$b_n, c_n in NN$とおけば
$ b_(n + 1)/c_(n + 1) = frac(N c_n, b_n) frac(3 b_n^2 + N c_n^2, b_n^2 + 3 N c_n^2) $
