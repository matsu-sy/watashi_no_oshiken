import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "filename", "current"]

  connect() {
    // ここはなくてもOK。デバッグ用に置くなら console.log("connected")
  }

  preview() {
    const file = this.inputTarget.files?.[0]
    if (!file) return

    // ファイル名表示（任意）
    if (this.hasFilenameTarget) this.filenameTarget.textContent = file.name

    // 既存画像ブロックを隠す（任意）
    if (this.hasCurrentTarget) this.currentTarget.classList.add("hidden")

    // プレビュー表示
    const url = URL.createObjectURL(file)
    this.previewTarget.src = url
    this.previewTarget.classList.remove("hidden")

    // メモリ解放（画像ロード後）
    this.previewTarget.onload = () => URL.revokeObjectURL(url)
  }

  clear() {
    // 「選び直し」ではなく「クリア」用（任意）
    this.inputTarget.value = ""
    if (this.hasFilenameTarget) this.filenameTarget.textContent = "未選択"
    if (this.hasCurrentTarget) this.currentTarget.classList.remove("hidden")
    if (this.hasPreviewTarget) {
      this.previewTarget.src = ""
      this.previewTarget.classList.add("hidden")
    }
  }
}