import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["media", "transcript"];

  connect() {
    this.mediaTarget.addEventListener("timeupdate", this.updateProgress.bind(this));
    window.addEventListener("hashchange", this.handleHashChange.bind(this));
    this.handleHashChange();
  }

  handleHashChange() {
    const hash = window.location.hash;
    console.log(hash);
    if (hash.startsWith("#t=")) {
      const seconds = parseInt(hash.substring(3, hash.length - 1));
      this.mediaTarget.currentTime = seconds;
    }
  }

  updateProgress() {
    const currentTime = this.mediaTarget.currentTime;
    const segments = this.transcriptTarget.querySelectorAll("[data-starts][data-ends]");

    segments.forEach((segment) => {
      const startTime = parseFloat(segment.dataset.starts);
      const endTime = parseFloat(segment.dataset.ends);

      if (startTime < currentTime) {
        segment.classList.add("opacity-50");
      } else {
        segment.classList.remove("opacity-50");
      }

      if (startTime < currentTime && currentTime < endTime) {
        const scrollThreshold = 500; // Adjust this value to determine the scroll threshold

        if (Math.abs(segment.getBoundingClientRect().top) < scrollThreshold) {
          segment.scrollIntoView({ block: "start" });
        }

        segment.classList.add("link-underline-opacity-75");
      } else {
        segment.classList.remove("link-underline-opacity-75");
      }
    });
  }

  scrubTo(event) {
    const time = event.target.dataset.starts;
    this.mediaTarget.currentTime = parseFloat(time);
  }
}
