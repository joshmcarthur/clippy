import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["media", "transcript"];

  connect() {
    this.transcriptTarget.addEventListener("click", (event) => {
      if (event.target.classList.contains("transcript-segment")) {
        const time = event.target.dataset.starts;
        this.mediaTarget.currentTime = parseFloat(time);
      }
    });

    this.mediaTarget.addEventListener("timeupdate", () => {
      const currentTime = this.mediaTarget.currentTime;
      const segments = this.transcriptTarget.querySelectorAll(".transcript-segment");

      segments.forEach((segment) => {
        const startTime = parseFloat(segment.dataset.starts);
        const endTime = parseFloat(segment.dataset.ends);

        if (startTime < currentTime) {
          segment.classList.add("played");
        } else {
          segment.classList.remove("played");
        }

        if (startTime < currentTime && currentTime < endTime) {
          const scrollThreshold = 500; // Adjust this value to determine the scroll threshold

          if (Math.abs(segment.getBoundingClientRect().top) < scrollThreshold) {
            segment.scrollIntoView({ block: "start" });
          }

          segment.classList.add("playing");
        } else {
          segment.classList.remove("playing");
        }
      });
    });
  }
}
