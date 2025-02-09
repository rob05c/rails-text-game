// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"

import chatChannel from "channels/chat_channel";

$(document).on('turbolinks:load', function () {
  $("form#set_name").on('submit', function(e){
    e.preventDefault();
    let name = $('#add_name').val();
    sessionStorage.setItem('chat_room_name', name)
    chatChannel.announce({ name, type: 'join'})
    $("#modal").css('display', 'none');
  });

  $("form#send_message").on('submit', function(e){
    e.preventDefault();
    let message = $('#message').val();
    if (message.length > 0) {
      chatChannel.speak(message);
      $('#message').val('')
    }
  });

  $(window).on('beforeunload', function() {
    let name = sessionStorage.getItem('chat_room_name')
    chatChannel.announce({ name, type: 'leave'})
  });
})
