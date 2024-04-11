import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "segmentStartInput", "segmentEndInput"];
  TYPE_RANGE = "Range";

  resolveSegmentId(node) {
    if (node?.dataset?.segmentId) {
      return node.dataset.segmentId;
    } else if (node.parentElement) {
      return this.resolveSegmentId(node.parentElement);
    }
  }

  connect() {
    // on selection change (like using keyboard arrows)
    document.addEventListener("selectionchange", this.selectionChanged.bind(this));

    // mouseup with editor scope
    this.element.addEventListener("mouseup", this.selectionChanged.bind(this));

    this.selectionChanged();
  }

  selectionChanged() {
    this.buttonTarget.disabled = true;

    const selection = document.getSelection();

    if (selection.type !== this.TYPE_RANGE) {
      return;
    }

    const range = selection.getRangeAt(0);

    // We can get a broad list of segments by looking at the DOM nodes in the range
    const segmentEls = Array.from(range.cloneContents().querySelectorAll("[data-segment-id]"));
    let segmentIds = segmentEls.map((el) => el.dataset.segmentId);

    // BUT - only entirely contained nodes will be extracted. So we need to check the start and end nodes,
    // and if they are not entirely contained, we need to add them to the list.
    segmentIds.push(this.resolveSegmentId(range.startContainer));
    segmentIds.push(this.resolveSegmentId(range.endContainer));

    // Take advantage of segment IDs being inherently sequential to find the start and end of the selection
    segmentIds = Array.from(new Set(segmentIds.filter((id) => id).sort()));

    if (segmentIds.length > 0) {
      this.buttonTarget.disabled = false;
      this.segmentStartInputTarget.value = segmentIds[0];
      this.segmentEndInputTarget.value = segmentIds[segmentIds.length - 1];
    }
  }
}
