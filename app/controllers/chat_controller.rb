class ChatController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    Rails.logger.warn "Chat session Initialized\n"
  end

  def user_msg(ev, msg)
    broadcast_message ev, {
      user_name:  current_user.username,
      received:   Time.now.to_s(:short),
      msg_body:   ERB::Util.html_escape(msg)
      }
  end

  def new_message
    user_msg :new_message, message[:msg_body].dup
  end

  def new_user
    connection_store[:user] = { user_name: current_user.username }
    broadcast_user_list
  rescue Exception => e
    Rails.logger.error(e.message)
  end

  def delete_user
    connection_store[:user] = nil
    broadcast_user_list
  end

  def broadcast_user_list
    users = connection_store.collect_all(:user)
    broadcast_message :user_list, users
  end

end
