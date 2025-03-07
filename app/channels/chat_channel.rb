require_relative '../helpers/application_helper'

require 'ruby-text-game'

class ChatChannel < ApplicationCable::Channel
  def subscribed
    logger.info "DEBUGA ChatChannel.subscribed user id '#{verified_user.id}' name '#{verified_user.name}'"
    stream_from "chat_channel#{verified_user.id}"

    logger.info 'DEBUGA ChatChannel.subscribed streaming'

    @user = verified_user
    name = @user.name
    world = ApplicationHelper.get_world

    msg = ''
    world.lock.synchronize do
      player = world.get_player_by_name(name)
      logger.info "DEBUGA nonexistent player '#{name}'" if player.nil?
      logger.info "DEBUGA ChatChannel.subscribed got player #{player}"

      inv_str = RubyTextGame.inventory_str(world, player, [])

      logger.info "DEBUGA ChatChannel.subscribed player inventory #{inv_str}"

      RubyTextGame.drop(world, player, %w[drop goblin])

      room_desc = RubyTextGame.look_str(world, player, nil)
      msg = room_desc

      player.send_fn = lambda { |msg|
        data = {}
        data['message'] = msg
        ActionCable.server.broadcast("chat_channel#{verified_user.id}", data)
      }

      player.send(msg)
    end

    # data = {}
    # data["message"] = msg
    # ActionCable.server.broadcast("chat_channel#{verified_user.id}", data)

    # Thread.new do
    #   sleep 5
    #   ActionCable.server.broadcast("chat_channel#{verified_user.id}", "after5")
    # end
  end

  def unsubscribed
    logger.info 'DEBUGA ChatChannel.unsubscribed'
    name = @user.name
    world = ApplicationHelper.get_world
    world.lock.synchronize do
      player = world.get_player_by_name(name)
      player.send_fn = nil unless player.nil?
    end

    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    logger.info 'DEBUGA ChatChannel.receive'
    logger.info "DEBUGA ChatChannel.receive user '#{@user.name}'"

    # gls = ApplicationHelper.get_global_str
    # logger.info "DEBUGA ChatChannel.receive global str is #{gls}"
    # ApplicationHelper.set_global_str(gls + "a")

    # gls2 = ApplicationHelper.get_global_str
    # logger.info "DEBUGA ChatChannel.receive new global str is #{gls2}"

    Chat.create(username: data['username'], message: data['message'])
    ActionCable.server.broadcast("chat_channel#{verified_user.id}", data)
  end

  def speak(data)
    logger.info "DEBUGA ChatChannel.speak '" + data['message'] + "'"
    logger.info "DEBUGA ChatChannel.speak user '#{@user.name}'"

    msg = data['message']
    world = ApplicationHelper.get_world

    msg = msg.strip
    # if the user just hit enter with no text (or only whitespace), just print a prompt
    if msg == ''
      return # TODO: send prompt
    end

    # lmsg = msg.lower()
    lmsg = msg.tr('  ', ' ')
    args = lmsg.split(' ')

    cmd = RubyTextGame.get_command(args)
    world.lock.synchronize do
      player = world.get_player_by_name(@user.name)
      logger.info "DEBUGA ChatChannel.speak nonexistent player '#{name}'" if player.nil?
      logger.info "DEBUGA ChatChannel.speak got player #{player}"

      cmd.call(world, player, args)
    end

    # gls = ApplicationHelper.get_global_str
    # logger.info "DEBUGA ChatChannel.speak global str is #{gls}"

    # ApplicationHelper.set_global_str(gls + "b")
    # gls2 = ApplicationHelper.get_global_str
    # logger.info "DEBUGA ChatChannel.speak new global str is #{gls2}"

    # ActionCable.server.broadcast "chat_channel", { message: data["message"], sent_by: data["name"] }
  end

  def announce(data)
    ActionCable.server.broadcast "chat_channel#{verified_user.id}", { chat_name: data['name'], type: data['type'] }
  end
end
