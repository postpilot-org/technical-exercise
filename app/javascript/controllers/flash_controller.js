import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  remove() {
    this.element.parentNode.removeChild(this.element);
  }
}
