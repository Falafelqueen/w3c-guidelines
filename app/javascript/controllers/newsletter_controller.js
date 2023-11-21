import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="newsletter"
export default class extends Controller {
  static targets = ["form", "emailInput", "thankYouMessage"];
  connect() {}

  subscribe(e) {
    e.preventDefault();
    console.log(e);
    const baseUrl = this.formTarget.action;
    const url = `${baseUrl}/v3/forms/5178353/subscribe`;
    const email = this.emailInputTarget.value;
    if (this.validEmailTest(email)) {
      setTimeout(() => {
        this.#postData(url, email);
      }, 1500);
      // show thank you message
      this.formTarget.style.display = "none";
      this.thankYouMessageTarget.style.display = "block";
      // wait
      // close pop-up
    } else {
      // show invalid email message
    }
  }

  validEmailTest(email) {
    const re =
      /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
  }

  #postData(url, email) {
    const APIkey = "GfC0B6ck4C65z_nIicMUWQ";
    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=utf-8" },
      body: JSON.stringify({ api_key: APIkey, email: email }),
    })
      .then((response) => response.json())
      .then((data) => {
        // if the response is subscription
        console.log(data.subscription);
        if (data.subscription) {
          // close pop-up
        }
      });
  }
}
