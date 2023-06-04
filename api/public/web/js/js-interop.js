// Sets up a channel to JS-interop with Flutter
(function () {
  "use strict";
  // This function will be called from Flutter when it prepares the JS-interop.
  window._stateSet = function () {
    // This is done for handler callback to be updated from Flutter as well as HTML
    window._stateSet = function () {};

    // The state of the flutter app, see `class _MyAppState` in [src/client.dart].
    let appState = window._appState;
  };
})();
