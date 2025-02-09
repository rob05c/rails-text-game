// app/javascript/channels/chat_channel.js
import consumer from "./consumer"
consumer.subscriptions.create({ channel: "ChatChannel", room: "Best Room" })
// app/javascript/channels/appearance_channel.js
import consumer from "./consumer"
consumer.subscriptions.create({ channel: "AppearanceChannel" })

