document.addEventListener('turbolinks:load', function () {
  let channel = 'NotificationsChannel';
  App.notifications = App.cable.subscriptions.create(channel, {
    connected: function () {
      App.cable.log("Connected to", channel);
    },
    disconnected: function () {
      App.cable.log("Disconnected from", channel)
    },
    received(data) {
      App.cable.log("Received from", channel);
      App.cable.log(data);

      App.dispatchEvents('notifications.' + data.action, data);
    },
    listen(gid) {
      App.cable.log("Listening to", channel, gid);
      this.perform('listen', { gid: gid })
    }
  });
});
