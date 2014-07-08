class ChatController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    Rails.logger.debug "Chat session Initialized\n"
  end

  def client_connected
    connection_store[:user] = { username: current_user.username }
    broadcast_user_list
  rescue Exception => e
    Rails.logger.error(e.message)
  end

  def client_disconnected
    Rails.logger.debug("client_disconnected")
    connection_store[:user] = nil
    broadcast_user_list
  rescue Exception => e
    Rails.logger.error(e.message)
  end

  def user_msg(event, msg)
    broadcast_message event, {
      username:  current_user.username,
      received:   Time.now.to_s(:short),
      msg_body:   ERB::Util.html_escape(msg)
    }
  end

  def new_message
    user_msg :new_message, strip_tags(sanitize(message[:msg_body]))
  end

  def broadcast_user_list
    users = connection_store.collect_all(:user)
    broadcast_message :user_list, users
  end

end
