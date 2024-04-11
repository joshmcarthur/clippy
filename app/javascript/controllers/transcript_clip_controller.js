import SelectionController from "controllers/selection_controller";

export default class extends SelectionController {
  static targets = ["toolbar", "segmentStartInput", "segmentEndInput"];

  resolveSegmentId(node) {
    const elements = [node.parentElement, node.previousElementSibling, node.nextElementSibling];

    return elements.find((element) => element?.dataset?.segmentId)?.dataset?.segmentId;
  }

  selectionChanged(selection) {
    let anchorNodeSegmentId = this.resolveSegmentId(selection.anchorNode) || this.resolveSegmentId(selection.focusNode);
    let focusNodeSegmentId = this.resolveSegmentId(selection.focusNode);

    if (anchorNodeSegmentId) {
      this.lastAnchorNodeSegmentId = anchorNodeSegmentId;
    }

    if (focusNodeSegmentId) {
      this.lastFocusNodeSegmentId = focusNodeSegmentId;
    }

    this.segmentStartInputTarget.value = this.lastAnchorNodeSegmentId;
    this.segmentEndInputTarget.value = this.lastFocusNodeSegmentId;
  }
}
