import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];
  static values = {
    discountName: String,
  };
  static outlets = ["toast"];

  connect() {
    const toastContainer = document.getElementById("toast-container");
    this.toastController = this.application.getControllerForElementAndIdentifier(toastContainer, "toast");

    if (!this.toastController) {
      console.error("Toast controller not found!");
    } else {
      console.log("Toast controller found and connected");
    }
  }

  click(event) {
    if (this.hasToastOutlet) {
      console.log("Triggering toast notification");
      this.toastOutlet.showToast("Starting export... Your download will begin shortly.", "success");
    } else {
      console.error("Cannot show toast - controller not found");
    }
  }
}
