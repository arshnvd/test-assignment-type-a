// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  // Connect only if user is signed in

  document.addEventListener('DOMContentLoaded', function () {
    App.environment     = document.querySelector("[data-environment]").getAttribute('data-environment');

    App.cable = ActionCable.createConsumer();

    App.cable.log = function (...messages) {
      if (ActionCable.debugging) { console.log("[ActionCable]", ...messages); }
    };

    // Console log debugging messages

    App.environment === 'development' && ActionCable.startDebugging();

    // Find subscriptions by channel name, usage: App.findSubscriptions('notifications')

    App.findSubscriptions = function (identifier) {
      identifier = "{\"channel\":\"" + identifier.replace(/^\w/, function (c) {
        return c.toUpperCase();
      }) + "Channel\"}";

      return App.cable.subscriptions.findAll(identifier);
    };

    App.dispatchEvents = function (eventName, detail) {
      let event = new CustomEvent(eventName, { detail: detail });
      document.dispatchEvent(event);

      // App.cable.log('Triggered event', event);

      let uid = !!detail.data ? detail.data.uid : detail.uid;

      !!uid && dispatchUniqueEvent();

      function dispatchUniqueEvent() {
        let uniqueName  = eventName + '.' + uid;
        let uniqueEvent = new CustomEvent(uniqueName, { detail: detail });
        document.dispatchEvent(uniqueEvent);

        App.cable.log('Triggered event', uniqueName);
      }
    }
  });
}).call(this);