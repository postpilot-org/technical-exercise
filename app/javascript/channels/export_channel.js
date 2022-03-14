import consumer from "channels/consumer"

consumer.subscriptions.create("ExportChannel", {
  connected() {
    console.log('Connected Channel');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);
    let blob = new Blob([data['content']], { type: 'text/csv' });
    let csv_download_link = document.createElement('a');
    csv_download_link.href = window.URL.createObjectURL(blob);
    csv_download_link.download = data['filename'];
    csv_download_link.click();
  }
});
