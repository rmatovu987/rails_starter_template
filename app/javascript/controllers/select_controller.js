import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="select"
export default class extends Controller {
  static targets = [ "hiddenInput" ]

  // Define the value property to get the target field selector
  static values = {
    targetFieldSelector: String
  }

  // This method is called when the 'change' event is triggered on the select
  updateTarget(event) {
      this.hiddenInputTarget.value = event.target.value
  }

  // You can add a connect method if you need to set an initial value
  // connect() {
  //   // Optional: Find the target field and try to set the initial selection
  //   const targetField = document.querySelector(this.targetFieldSelectorValue);
  //   if (targetField && targetField.value) {
  //     // Logic to programmatically set the selection in the Preline select based on targetField.value
  //     // This might involve dispatching a change event or interacting directly with Preline's JS API if available.
  //     // This part can be tricky and depends on Preline's implementation details.
  //     // For simply attaching the selected value on change, updateTarget is sufficient.
  //   }
  // }
}
