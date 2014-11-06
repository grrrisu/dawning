# proxy to player on sim
# holds connection to player server and the websocket connection to the browser
class PlayerProxy < Sim::Net::PlayerProxy

  attr_accessor :websocket

  def initialize options
    role = options[:role] || :player
    super(UUID.new.generate, role)
    connect_to_players_server(Rails.root.join('tmp', 'sockets', 'players.sock').to_s)
  end

  def send_message action, params = {}
    @sim_connection.send_object player_id: id, action: action, params: params
  end

  def message_received message
    if websocket
      Rails.logger.debug("sending to browser #{message}")
      websocket.send_message message[:action], message[:answer]
    else
      Rails.logger.warn("could not send message #{message} to browser as websocket is not yet available")
    end
  end

end
