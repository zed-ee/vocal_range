// this content-script plays role of medium to publish/subscribe messages from webpage to the background script

// this object is used to make sure our extension isn't conflicted with irrelevant messages!
var rtcmulticonnectionMessages = {
    'screenshot': true
};
/*
// this port connects with background script
var port = chrome.runtime.connect();

// if background script sent a message
port.onMessage.addListener(function(message) {
    // get message from background script and forward to the webpage
    window.postMessage(message, '*');
});
*/
// this event handler watches for messages sent from the webpage
// it receives those messages and forwards to background script
window.addEventListener('message', function(event) {
    // if invalid source
    if (event.source != window)
        return;

    // it is 3rd party message
    if (!rtcmulticonnectionMessages[event.data]) return;

    // if browser is asking whether extension is available
    if (event.data == 'screenshot') {
      chrome.tabCapture.capture({
         video: true,
         audio:false,
         videoConstraints: {
             mandatory: {
              chromeMediaSource: 'tab'
          }
         }
      }, function (stream) {
        
      })
    }

});

// inform browser that you're available!
window.postMessage('zz_rtcmulticonnection-extension-loaded', '*');
