# proxy to player on sim
# holds connection to player server and the websocket connection to the browser
class PlayerProxy < Sim::Net::PlayerProxy

  attr_accessor :websocket

  def initialize options
    role = options[:role] || :player
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

end
