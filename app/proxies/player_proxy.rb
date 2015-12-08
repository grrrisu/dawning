# proxy to player on sim
# holds connection to player server and the websocket connection to the browser
class PlayerProxy < Sim::Net::PlayerProxy

  attr_reader :user
  attr_accessor :websocket

  def initialize user, options
    @user = user
    role  = allowed_role options[:role]
    super(UUID.new.generate, role)
  end

  def message_received message
    if websocket
      Rails.logger.debug("sending #{message[:action]} to browser")
      websocket.send_message message[:action], message[:answer]
    else
      Rails.logger.warn("could not send message #{message} to browser as websocket is not yet available")
    end
  end

private

  def allowed_role role
    case role
      when :admin then user.admin? ? :admin : :player
      else :player
    end
  end

end
