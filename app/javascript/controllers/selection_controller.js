import { Controller } from "@hotwired/stimulus";

/**
 * A controller that allows text to be 'clipped' from a page.
 * element - The element containing text to clip from
 */
export default class extends Controller {
  static targets = ["toolbar"];
  TYPE_RANGE = "Range";

  connect() {
    this.toolbarTarget.classList.add("d-none");

    // on selection change (like using keyboard arrows)
    document.addEventListener("selectionchange", this.update.bind(this));

    // mouseup with editor scope
    this.element.addEventListener("mouseup", this.update.bind(this));
  }

  /**
   * Get X, Y and selection width
   */
  getSelectionCoordinates(selection) {
    if (!selection.rangeCount) return false;

    const r = selection.getRangeAt(0);
    const clip = r.getClientRects();

    if (!clip.length) return false;

    let { x, y, width } = clip[0];
    x -= this.element.getBoundingClientRect().left;
    y -= this.element.getBoundingClientRect().top;

    return { x, y, width };
  }

  /**
   * Given the selection, find the start and end of the selection.
   * We can use baseNode and extentNode for this?
   */
  selectionChanged(selection) {
    // Override this method to handle selection changes
  }

  /**
   * Given the selection, move the toolbar to the center of selection.
   */
  update() {
    const selection = document.getSelection();
    const coordinates = this.getSelectionCoordinates(selection);

    if (coordinates && selection.type === this.TYPE_RANGE) {
      this.selectionChanged(selection);

      const toolbarX = coordinates.width / 2 + coordinates.x;

      this.toolbarTarget.style.setProperty("--top", `${coordinates.y}px`);
      this.toolbarTarget.style.setProperty("--left", `${toolbarX}px`);
      this.toolbarTarget.classList.remove("d-none");
    } else {
      this.toolbarTarget.classList.add("d-none");
    }
  }
}
