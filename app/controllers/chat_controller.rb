class ChatController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    Rails.logger.warn "Chat session Initialized\n"
  end

  def client_connected
    connection_store[:user] = { user_name: current_user.username }
    broadcast_user_list
  rescue Exception => e
    Rails.logger.error(e.message)
  end

  def client_disconnected
    Rails.logger.warn("client_disconnected")
    connection_store[:user] = nil
    broadcast_user_list
  rescue Exception => e
    Rails.logger.error(e.message)
  end

  def user_msg(event, msg)
    broadcast_message event, {
      user_name:  current_user.username,
      received:   Time.now.to_s(:short),
      msg_body:   ERB::Util.html_escape(msg)
    }
  end

  def new_message
    user_msg :new_message, message[:msg_body].dup
  end

  def broadcast_user_list
    users = connection_store.collect_all(:user)
    broadcast_message :user_list, users
  end

end
