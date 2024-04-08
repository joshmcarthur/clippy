import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

  connect() {
    document.body.addEventListener("dragover", this.dragOver.bind(this));
    document.body.addEventListener("drop", this.drop.bind(this));
    this.progressBar = Turbo.session.adapter.progressBar;
    this.inputTarget.addEventListener("direct-upload:progress", this.setProgress.bind(this));
  }

  dragOver(event) {
    event.preventDefault();
  }

  setProgress(event) {
    const { progress } = event.detail;
    this.progressBar.setValue(progress);
    this.progressBar.show();
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
