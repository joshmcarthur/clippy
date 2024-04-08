import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    resetPath: String,
  };

  connect() {
    this.valueWas = this.element.value;
    this.element.addEventListener("input", this.inputValueDidChange.bind(this));
  }

  inputValueDidChange() {
    if (this.valueWas !== "" && this.element.value === "") {
      this.reset();
    } else {
      this.valueWas = this.element.value;
      this.submit();
    }
  }

  submit() {
    this.element.form.requestSubmit();
  }

  reset() {
    window.location = this.resetPathValue + "?q=";
  }
}
