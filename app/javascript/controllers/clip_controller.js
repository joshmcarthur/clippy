import { Controller } from "@hotwired/stimulus";

/**
 * This controller allows 'clipping' of any text selection in the document.
 * It requires elements have data-starts and data-ends attributes to be considered
 * to bound the selection. data-starts and data-ends are assumed to be a float
 * representing the start and end time of a segment in seconds.
 */
export default class extends Controller {
  static targets = ["button", "rangeStartsInput", "rangeEndsInput", "message"];
  TYPE_RANGE = "Range";

  resolveRangeNode(node) {
    if (node?.dataset?.starts && node?.dataset?.ends) {
      return node;
    } else if (node.parentElement) {
      return this.resolveRangeNode(node.parentElement);
    }
  }

  connect() {
    // on selection change (like using keyboard arrows)
    document.addEventListener("selectionchange", this.selectionChanged.bind(this));

    // mouseup with editor scope
    this.element.addEventListener("mouseup", this.selectionChanged.bind(this));

    // Preserve the original message
    this.originalMessage = this.messageTarget.innerText;

    this.selectionChanged();
  }

  resolveSegmentEls(range) {
    // We can get a broad list of segments by looking at the DOM nodes in the range
    // We use the timestamps on the nodes rather than the segments because it's how a clip
    // is created, and the timestamps can be used to describe the selection.
    const segmentEls = Array.from(range.cloneContents().querySelectorAll("[data-starts][data-ends]"));

    // BUT - only entirely contained nodes will be extracted. So we need to check the start and end nodes,
    // and if they are not entirely contained, we need to add them to the list.
    segmentEls.push(this.resolveRangeNode(range.startContainer));
    segmentEls.push(this.resolveRangeNode(range.endContainer));

    // Remove any empty elements and then sort by the start time of the segment
    return segmentEls.filter((el) => el).sort((a, b) => parseFloat(a.dataset.starts) - parseFloat(b.dataset.starts));
  }

  describeSelection(startEl, endEl) {
    const start = parseFloat(startEl);
    const end = parseFloat(endEl);
    const duration = end - start;

    return `Selected ${duration.toFixed(2)} seconds to clip`;
  }

  selectionChanged() {
    this.buttonTarget.disabled = true;

    const selection = document.getSelection();

    if (selection.type !== this.TYPE_RANGE) {
      this.messageTarget.innerText = this.originalMessage;
      return;
    }

    const range = selection.getRangeAt(0);
    const els = this.resolveSegmentEls(range);

    if (els.length > 0) {
      const starts = els[0].dataset.starts;
      const ends = els[els.length - 1].dataset.ends;

      this.buttonTarget.disabled = false;
      this.rangeStartsInputTarget.value = starts;
      this.rangeEndsInputTarget.value = ends;

      this.messageTarget.innerText = this.describeSelection(starts, ends);
    }
  }
}
