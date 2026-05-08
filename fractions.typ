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

== Newton法

Newton法は、$f(x) = 0$の根$x = alpha$の付近で、$(a_n, f(a_n))$における接線
$ y - f(a_n) = f'(a_n)(x - a_n) $
と$x$軸、すなわち直線$y = 0$との交点の座標$(a_(n + 1), 0)$における$x$成分$a_(n + 1)$がもとの$a_n$より根$alpha$に近づくことを利用した近似法であり、端的に言えば
$ 0 - f(a_n) = f'(a_n)(a_(n + 1) - a_n) $
すなわち漸化式
$ a_(n + 1) = a_n - frac(f(a_n), f'(a_n)) $
を用いて近似を行う方法である。

例えば$f(x) = x^2 - N$とおくと、$f'(x) = 2x$であるから、$sqrt(N)$の近傍で
$ a_(n + 1) = a_n - frac(a_n^2 - N, 2 a_n) = 1/2 (a_n + N / a_n) $
を繰り返し適用することで、$a_n$は$sqrt(N)$に収束する。

また平方根においてNewton法は$3$次収束することが知られている。

あるいは$a_n = b_n/c_n$、ただし$b_n, c_n in NN$とおけば
$ b_(n + 1)/c_(n + 1) = 1/2 (b_n/c_n + N (c_n/b_n)) = frac(b_n^2 + N c_n^2, 2 b_n c_n) $
とも書ける。

== Aitkenの$delta^2$加速法

Richardsonの加速法とは、ある数列$a_n$とその収束値$lim_(n -> infinity) x_n = alpha$について、その誤差が収束率$gamma$と係数$C$を用いて
$ a_n - alpha approx C gamma^n $
と表せるとき、$a_(n + 1) - gamma a_n$を用いることによって$C$を消去して
$ a_(n + 1) - gamma a_n approx alpha(1 - gamma) $
すなわち
$ alpha approx frac(a_(n + 1) - gamma a_n, 1 - gamma) $
と書けることを利用して、新たに$(hat(a)_n)$を
$ hat(a)_n = frac(a_(n + 1) - gamma a_n, 1 - gamma) $
と定義する方法である。この数列はもとの数列$(a_n)$より$alpha$に近いため、より速く収束する。

Aitkenの$delta^2$加速法とは、上記の収束率$gamma$が未知のときにこれを
$ gamma_((n)) approx frac(a_(n + 2) - a_(n + 1), a_(n + 1) - a_n) $
と近似して上のRichardsonの加速法を適用する方法である。

実際にこれを代入して
$
  hat(a)_n &= frac(a_(n + 1) - gamma_((n)) a_n, 1 - gamma_((n))) = frac(a_(n + 1) - frac(a_(n + 2) - a_(n + 1), a_(n + 1) - a_n) a_n, 1 - frac(a_(n + 2) - a_(n + 1), a_(n + 1) - a_n)) = frac(a_(n + 2) a_n - a_(n + 1)^2, a_(n + 2) - 2 a_(n + 1) + a_n) \
  &= frac(a_(n + 2) a_n + (- 2 a_(n + 1) + a_n) a_n - a_(n + 1)^2 - (- 2 a_(n + 1) + a_n) a_n, a_(n + 2) - 2 a_(n + 1) + a_n) \
  &= frac((a_(n + 2) - 2 a_(n + 1) + a_n) a_n - (a_(n + 1)^2 - 2 a_(n + 1) a_n + a_n^2), a_(n + 2) - 2 a_(n + 1) + a_n) \
  &= a_n - frac((a_(n + 1) - a_n)^2, a_(n + 2) - 2 a_(n + 1) + a_n)
$
を得る。ここで、$delta a_n = a_(n + 1) - a_n$、$delta^2 a_n = a_(n + 2) - 2 a_(n + 1) + a_n$とおくことにより、Aitkenの$delta^2$加速法における加速列
$ hat(a)_n = a_n - frac(delta a_n^2, delta^2 a_n) $
を得る。

さて、前節のNewton法で得られる数列について
$ a_(n + 1) = 1/2 (a_n + N / a_n), wide a_(n + 2) = 1/2 (a_(n + 1) + N / a_(n + 1)) $
であるから、$delta a_n$および$delta^2 a_n$を計算すると
$
    delta a_n & = a_(n + 1) - a_n = - 1/2 (a_n - N / a_n) \
  delta^2 a_n & = a_(n + 2) - 2 a_(n + 1) + a_n \
              & = - 1/2 (a_(n + 1) - N / a_(n + 1)) + 1/2 (a_n - N / a_n) \
              & = (-1/2)^2 [-2 (a_(n + 1) - N / a_(n + 1)) + 2 (a_n - N / a_n)] \
              & = (-1/2)^2 [- (a_n + N / a_n) + 4 N (a_n - N / a_n)^(-1) + 2 (a_n - N / a_n)] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) [- (a_n + N / a_n)^2 + 4 N + 2 (a_n + N / a_n) (a_n - N / a_n)] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) [- a_n^2 - 2 N - (N / a_n)^2 + 4 N + 2 a_n^2 - 2 (N / a_n)^2] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) [a_n^2 + 2 N - 3 (N / a_n)^2] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) (a_n - N / a_n) (a_n + 3 N/ a_n)
$
より加速列として
$
  hat(a)_n = a_n - frac(delta a_n^2, delta^2 a_n) & = a_n - (a_n - N / a_n)^cancel(2) (a_n + N / a_n) cancel((a_n - N / a_n)^(-1)) (a_n + 3 N / a_n)^(-1) \
  & = [a_n (a_n + 3 N / a_n) - (a_n - N / a_n) (a_n + N / a_n)](a_n + 3 N / a_n)^(-1) \
  & = [(cancel(a_n^2) + 3 N) - (cancel(a_n^2) - N^2/a_n^2)](a_n + 3 N / a_n)^(-1) \
  & = (3 N + N^2 / a_n^2) (a_n + 3 N / a_n)^(-1) \
  & = N / a_n (3 a_n + N / a_n) (a_n + 3 N / a_n)^(-1)
$
が得られる。

ここで、数列$(a_n)$の十分大きい項$a_i$を求めて加速列$(hat(a)_n)$を生成し、$hat(a)_i$を求めてもいいが、一般には$a_n <- hat(a)_(n - 1)$としてしまい漸化式とみなして反復する方法がとられる。これはいわば加速列の加速列の…加速列を求めることであり、この列がより速く真の値に収束することは、加速法の原理からも明らかであろう。

$
  tilde(a)_(n + 1) = (N / tilde(a)_n) frac(3 tilde(a)_n + (N / tilde(a)_n), tilde(a)_n + 3 (N / tilde(a)_n))
$
