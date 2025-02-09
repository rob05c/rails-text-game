class ChatChannel < ApplicationCable::Channel
  def subscribed
    logger.info "DEBUGA ChatChannel.subscribed"
    stream_from 'chat_channel'

    logger.info "DEBUGA ChatChannel.subscribed streaming"

    Thread.new do
      sleep 5
      ActionCable.server.broadcast('chat_channel', "after5")
    end
  end

  def unsubscribed
    logger.info "DEBUGA ChatChannel.unsubscribed"
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    logger.info "DEBUGA ChatChannel.receive"
    Chat.create(username: data['username'], message: data['message'])
    ActionCable.server.broadcast('chat_channel', data)
  end

  def speak(data)
    logger.info "DEBUGA ChatChannel.speak '" + data['message'] + "'"
    ActionCable.server.broadcast "chat_channel", { message: data["message"], sent_by: data["name"] }
  end

  def announce(data)
    ActionCable.server.broadcast "chat_channel", { chat_name: data["name"], type: data["type"] }
  end
end
