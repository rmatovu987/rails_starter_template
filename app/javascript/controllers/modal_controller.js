import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"]

export default class extends Controller {
  // static targets = [ "modal" ]

  connect() {
    if (this.element.dataset.showOnInit === "true") {
      this.open();
    }
  }

  open() {
    this.element.showModal();
  }

  close() {
    this.element.close();
  }

  closeWithDialog() {
    this.element.close(); // Using the dialog's built-in close
  }

  // You can add more actions here, e.g., handling form submissions within the modal
}