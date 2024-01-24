import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="device-log"
export default class extends Controller {
  connect() {
    document.cookie = `device=${window.innerWidth}`;
    console.log("device", window.innerWidth);
  }
}
