#let fix-indent(body, amount: 1em) = {
  // 段落の基本設定
  set par(first-line-indent: (amount: amount, all: true))

  // インデントするか判断するために状態フラグを保持
  let aft = state("__aft__", false)

  // 特定ブロックの後は立てる
  show math.equation.where(block: true): it => {
    it
    aft.update(true)
  }
  show enum: it => {
    it
    aft.update(true)
    // context v(-par.leading)
  }
  show list: it => {
    it
    aft.update(true)
    // context v(-par.leading)
  }
  show terms: it => {
    it
    aft.update(true)
    // context v(-par.leading)
  }
  show align: it => {
    it
    aft.update(true)
    // context v(-par.leading)
  }
  show raw: it => {
    it
    aft.update(true)
    // context v(-par.leading)
  }
  // 空行があれば戻す
  show parbreak: it => {
    aft.update(false)
    it
  }

  // フラグに応じてインデントを調整
  show par: it => context {
    if not it.first-line-indent.amount == 0em and aft.get() {
      aft.update(false)
      let args = it.fields()
      let _ = args.remove("body")
      // context v(-par.leading)
      par(..args, first-line-indent: 0em, it.body)
    } else {
      it
    }
  }

  // 本文
  body
}
