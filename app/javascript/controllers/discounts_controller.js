import { Controller } from '@hotwired/stimulus'
import { createConsumer } from '@rails/actioncable'

export default class extends Controller {
  static values = { id: Number };
  static targets = ['link'];

  connect() {
    console.log(this.linkTarget.innerText);
    this.channel = createConsumer().subscriptions.create({
      channel: 'DiscountsChannel',
      discount_id: this.idValue
    }, {
      received: (data) => {
        console.log(this.linkTarget.innerText);
        this.linkTarget.innerText = data.label;
        this.linkTarget.href = data.href;
      }
    })
  }
}
