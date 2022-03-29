import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="admin--text-box-counter"
export default class extends Controller {
  static targets = [ "source", "output" ]
  static classes = [ "error" ]
  static values = {
    current: { type: Number, default: 0 },
    maxLength: { type: Number, default: 250 }
  }

  initialize() {
    this.count()
  }

  count() {
    this.currentValue = this.sourceTarget.value.length
  }

  currentValueChanged() {
    this.updateDisplayedValue()
  }

  updateDisplayedValue() {
    if(this.currentValue > this.maxLengthValue) {
      this.sourceTarget.classList.add(this.errorClass)
    } else {
      this.sourceTarget.classList.remove(this.errorClass)
    }

    this.outputTarget.innerHtml = this.currentValue
    this.outputTarget.textContent = this.currentValue
  }
}
