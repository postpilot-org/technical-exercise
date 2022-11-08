import consumer from "channels/consumer"

consumer.subscriptions.create("FileDownloaderChannel", {
  connected() {
    console.log("CONNECTED")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const blob = new Blob([data['content']], { type: 'text/csv' });
    const link = document.createElement('a');
    const date = new Date().toJSON();

    link.href = window.URL.createObjectURL(blob);
    link.download = date + "_" + data['filename'];
    link.click();

    // this is necessary as link.click() does not work on the latest firefox
    // link.dispatchEvent(
    //   new MouseEvent('click', { 
    //     bubbles: true, 
    //     cancelable: true, 
    //     view: window 
    //   })
    // );

    // setTimeout(() => {
    //   // For Firefox it is necessary to delay revoking the ObjectURL
    //   window.URL.revokeObjectURL(data);
    //   link.remove();
    // }, 100);
  }
});
