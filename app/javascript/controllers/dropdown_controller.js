import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["list"];
  connect() {
    /*     console.log("Dropdown connected");
    window.addEventListener("click", (e) => {
      console.log(e.target);
      console.log(
        "checking classList",
        this.listTarget.classList.contains("display__list-container--active"),
        !e.target.matches(".display__list-container--active, .dropdown__btn")
      );
      if (
        !e.target.matches(".display__list-container--active, .dropdown__btn") &&
        this.listTarget.classList.contains("display__list-container--active")
      ) {
        console.log("trying to remove class");
        this.listTarget.classList.remove("display__list-container--active");
      } else {
        console.log("Doing nothing");
      }
    }); */
  }

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
