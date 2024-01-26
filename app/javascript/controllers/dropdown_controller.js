import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["list"];
  connect() {}

  toggleOpen(event) {
    event.preventDefault();
    const ariaValue = event.target.getAttribute("aria-expanded") == "true";
    const cardContainer = document.querySelector(".card__container");

    event.target.setAttribute("aria-expanded", !ariaValue);
    /* toggle class */
    console.log(
      "before: showing classlist from toggleOpen",
      this.listTarget.classList
    );
    this.listTarget.classList.toggle("display__list-container--active");

    const appliedFilters = document.querySelector(".applied-filters");
    if (this.listTarget.classList.contains("display__list-container--active")) {
      const extraMargin = this.listTarget.offsetHeight;
      if (appliedFilters) {
        appliedFilters.style.marginTop = `${extraMargin}px`;
      } else {
        cardContainer.style.marginTop = `${extraMargin}px`;
      }
    } else {
      if (appliedFilters) {
        appliedFilters.style.marginTop = "initial";
      }
      cardContainer.style.marginTop = "initial";
    }
    console.log(
      "after: showing classlist from toggleOpen",
      this.listTarget.classList
    );
  }
}
