import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["list"];
  connect() {}

  toggleOpen(event) {
    event.preventDefault();
    const ariaValue = event.target.getAttribute("aria-expanded") == "true";
    event.target.setAttribute("aria-expanded", !ariaValue);
    /* toggle class */
    console.log(
      "before: showing classlist from toggleOpen",
      this.listTarget.classList
    );
    this.listTarget.classList.toggle("display__list-container--active");
    console.log(
      "after: showing classlist from toggleOpen",
      this.listTarget.classList
    );
  }
}
