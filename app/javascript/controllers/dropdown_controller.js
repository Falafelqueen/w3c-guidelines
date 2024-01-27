import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["list"];
  connect() {}

  toggleOpen(event) {
    event.preventDefault();

    const ariaValue = event.target.getAttribute("aria-expanded") == "true";
    const cardContainer = document.querySelector(".card__container");
    const appliedFilters = document.querySelector(".applied-filters");

    const screenSize = window.innerWidth > 0 ? window.innerWidth : screen.width;

    console.log("screenSize", screenSize);

    event.target.setAttribute("aria-expanded", !ariaValue);

    this.listTarget.classList.toggle("display__list-container--active");

    /* On mobile devices */
    if (screenSize < 415) {
      if (
        this.listTarget.classList.contains("display__list-container--active")
      ) {
        /* Move everything down after opening the popup  */
        const extraMargin = this.listTarget.offsetHeight;
        if (appliedFilters) {
          appliedFilters.style.marginTop = `${extraMargin}px`;
        } else {
          cardContainer.style.marginTop = `${extraMargin}px`;
        }

        /* Close other opened dropdowns */
        const dropdowns = document.querySelectorAll(
          ".display__list-container--active"
        );
        dropdowns.forEach((dropdown) => {
          if (dropdown != this.listTarget) {
            dropdown.classList.remove("display__list-container--active");
          }
        });
      } else {
        if (appliedFilters) {
          appliedFilters.style.marginTop = "initial";
        }
        cardContainer.style.marginTop = "initial";
      }
    }
  }
}
