// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"

import chatChannel from "channels/chat_channel";

console.log("DEBUGx 0");
window.document.onload = function(e) {
  console.log("DEBUGx doc wdo");
}
console.log("DEBUGx 10");

function handle_message_send() {
  console.log("handle_message_send1");
  let txt = document.forms["send_message"]["send_message_input"].value

  const msgInput = document.getElementById("send_message_input");
  // select text after it's sent, which is usually convenient.
  // It makes it so the user can send something else by immediately typing, which overwrites the selected text,
  // or send the same command again by just hitting enter (e.g. keep going west)
  msgInput.select();

  // const msgForm = document.getElementById("send_message");
  // const txt = msgForm.value
  // msgForm.value = ""
  console.log("handle_message_send sending '" + txt + "'");
  chatChannel.speak(txt) // send text over websocket
  return false; // never submit the form
}

function init() {
  console.log("DEBUG init called");
  const msgForm = document.getElementById("send_message");
  msgForm.onsubmit = handle_message_send
  // msgForm.onclick="handle_message_send();"
}

init()

// $(document).on('turbolinks:load', function () {
//   console.log("DEBUGx doc tl load");

//   $("form#set_name").on('submit', function(e){
//     e.preventDefault();
//     let name = $('#add_name').val();
//     sessionStorage.setItem('chat_room_name', name)
//     chatChannel.announce({ name, type: 'join'})
//     $("#modal").css('display', 'none');
//   });

//   $("form#send_message").on('submit', function(e){
//     console.log("DEBUGx formsendmessage");

//     e.preventDefault();
//     let message = $('#message').val();
//     if (message.length > 0) {
//       chatChannel.speak(message);
//       $('#message').val('')
//     }
//   });

//   $(window).on('beforeunload', function() {
//     let name = sessionStorage.getItem('chat_room_name')
//     chatChannel.announce({ name, type: 'leave'})
//   });
// })
