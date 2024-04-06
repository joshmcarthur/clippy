import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    document.body.addEventListener("dragover", this.dragOver.bind(this));
    document.body.addEventListener("drop", this.drop.bind(this));
  }

  dragOver(event) {
    event.preventDefault();
  }

  drop(event) {
    event.preventDefault();
    const file = event.dataTransfer.files[0];
    const dataTransfer = new DataTransfer();

    if (file) {
      dataTransfer.items.add(file);
      this.inputTarget.files = dataTransfer.files;
      this.inputTarget.dispatchEvent(new Event("change"));
    }
  }
}
