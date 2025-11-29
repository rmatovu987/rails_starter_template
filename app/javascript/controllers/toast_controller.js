import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toast"
export default class extends Controller {
  connect() {
    const node = this.element;

    this.open()
  }

  open() {
    setTimeout(() => {
      this.element.remove()
    }, 5000)
  }

  close() {
    setTimeout(() => this.element.remove(), 1000)
  }
}
