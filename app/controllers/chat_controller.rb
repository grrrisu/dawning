class ChatController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  before_filter :find_player, only: [:new_user]

  def initialize_session
    puts "Session Initialized\n"
  end

  def system_msg(ev, msg)
    broadcast_message ev, {
      user_name: 'system',
      received: Time.now.to_s(:short),
      msg_body: msg
    }
  end

  def user_msg(ev, msg)
    broadcast_message ev, {
      user_name:  connection_store[:user][:user_name],
      received:   Time.now.to_s(:short),
      msg_body:   ERB::Util.html_escape(msg)
      }
  end

  def client_connected
    Rails.logger.warn "client #{client_id} message #{message} connection #{connection} connected"
    system_msg :new_message, "client #{client_id} connected"
  end

  def new_message
    user_msg :new_message, message[:msg_body].dup
  end

  def new_user
    unless current_user.admin? # FIXME admin must be player when on map
      @player.websocket = connection
      @player.websocket.send_message :new_message, { user_name: 'system', received: Time.now.to_s(:short), msg_body: 'registered!'}
    end

    connection_store[:user] = { user_name: sanitize(message[:user_name]) }
    broadcast_user_list
  rescue Exception => e
    Rails.logger.error(e.message)
  end

  def change_username
    connection_store[:user][:user_name] = sanitize(message[:user_name])
    broadcast_user_list
  end

  def delete_user
    connection_store[:user] = nil
    system_msg "client #{client_id} disconnected"
    broadcast_user_list
  end

  def broadcast_user_list
    users = connection_store.collect_all(:user)
    broadcast_message :user_list, users
  end

  def find_player
    unless current_user.admin? # FIXME admin must be player when on map
      @player = LevelProxy.find(message['level_id']).try(:find_player, current_user.id) or raise "no player found for level #{params[:level_id]} and user #{current_user}"
    end
  end

end
