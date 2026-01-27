import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  open() {
    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
    this._escHandler = e => { if (e.key === "Escape") this.close() }
    document.addEventListener("keydown", this._escHandler)
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
    document.removeEventListener("keydown", this._escHandler)
  }
}