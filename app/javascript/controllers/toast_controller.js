import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container"];

  connect() {
    console.log("Toast controller connected");
  }

  showToast(message, type = "notice") {
    console.log("Showing toast:", message, type);
    const toastHtml = this.buildToastHtml(message, type);
    this.containerTarget.insertAdjacentHTML("beforeend", toastHtml);
    const toast = this.containerTarget.lastElementChild;

    // Remove after 3 seconds
    setTimeout(() => {
      toast.classList.add("fade-out");
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  remove(event) {
    const toast = event.currentTarget.closest(".toast");
    toast.classList.add("fade-out");
    setTimeout(() => toast.remove(), 300);
  }

  buildToastHtml(message, type) {
    const icon = type === "success" ? "check" : "alert";
    return `
      <div class="toast toast-${type} bs-1 bg-${type}-light bt-${type} p-3 mb-2" data-transition-enter="fade-in">
        <div class="flex flex-between">
          <div class="flex flex-start">
            <div data-icon="${icon}"></div>
            <div class="ml-2">${message}</div>
          </div>
          <div class="pointer icon hover-dark" data-action="click->toast#remove">
            <div data-icon="cancel"></div>
          </div>
        </div>
      </div>
    `;
  }
}
