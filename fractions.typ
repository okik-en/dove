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

= 帰納的な展開

$N in NN without {0}$について、$sqrt(N)$の近似値を得たい。

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
