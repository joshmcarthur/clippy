import SelectionController from "controllers/selection_controller";

export default class extends SelectionController {
  static targets = ["toolbar", "segmentStartInput", "segmentEndInput"];

  selectionChanged(selection) {
    if (selection.anchorNode.parentElement.dataset.segmentId) {
      this.startElement = selection.anchorNode.parentElement;
    }

    if (selection.focusNode.parentElement.dataset.segmentId) {
      this.endElement = selection.focusNode.parentElement;
    }

    this.segmentStartInputTarget.value = this.startElement?.dataset?.segmentId;
    this.segmentEndInputTarget.value = this.endElement?.dataset?.segmentId;
  }
}
