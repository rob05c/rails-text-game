import consumer from "channels/consumer"

const chatChannel = consumer.subscriptions.create({ channel: "ChatChannel" }, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the chat!");
  },

  disconnected() {
    console.log("chat disconnected");
  },

  received(data) {
    console.log("chat received data '" + JSON.stringify(data) + "'");

    if (data.message) {
      let current_name = sessionStorage.getItem('chat_room_name')
      let msg_class = data.sent_by === current_name ? "sent" : "received"

      const messages = document.getElementById("messages");
      var content = document.createTextNode(data.message+"\n")
      messages.appendChild(content)
      // $('#messages').append(`<p class='${msg_class}'>` + data.message + '</p>')
    } else if(data.chat_room_name) {
      let name = data.chat_room_name;
      let announcement_type = data.type == 'join' ? 'joined' : 'left';
      // $('#messages').append(`<p class="announce"><em>${name}</em> ${announcement_type} the room</p>`)
    }

    // var sd = 'after-rcv';
    // var that = this
    // var fn = function() { that.speak(sd); }
    // setTimeout(fn, 3000);
  },

  speak(message) {
    console.log("chat speak '" + message + "'");

    let name = sessionStorage.getItem('chat_room_name')
    this.perform('speak', { message, name })
  },

  announce(content) {
    console.log("chat announce");

    this.perform('announce', { name: content.name, type: content.type })
  }
});

function handle_message_send() {
  console.log("handle_message_send0");
  const msgForm = document.getElementById("send_message");
  const txt = msgForm.value
  msgForm.value = ""
  chatChannel.speak(txt) // send text over websocket
  return false; // never submit the form
}

export default chatChannel;
