// Sets up a channel to JS-interop with Flutter
(function () {
  "use strict";

  function sendMessageToIframe(data) {
    const flutterIframe = document.getElementById("flutter-iframe");

    console.log("flutterIframe", flutterIframe);
    const payload = {
      data: data,
      messageType: "code-payload",
    };

    flutterIframe.contentWindow.postMessage(payload, "*");
  }

  window.addEventListener("message", function (event) {
    sendMessageToIframe(event.data);
  });
})();
