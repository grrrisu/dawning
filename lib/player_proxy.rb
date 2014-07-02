# proxy to player on sim
# holds connection to player server and the websocket connection to the browser
class PlayerProxy

  attr_reader :id, :sim_connection
  attr_accessor :websocket

  def initialize connection, options
    @id   = UUID.new.generate
    @role = options[:role] || :player
    @old_connection = connection # FIXME tmp!
    connect_to_players_server
  end

  def action action, params = nil
    Rails.logger.warn "send player action #{action} with #{params.inspect}"
    @old_connection.send_player_action id, action, params
    #sim_connection.send_object id, action, params
  end

  def send_message action, *params
    @sim_connection.send_object player_id: id, action: action, params: params
  end

  def connect_to_players_server
    Rails.logger.warn("connecting to player server...")
    EM.connect_unix_domain(Rails.root.join('tmp', 'sockets', 'players.sock').to_s, Handler) do |handler|
      Rails.logger.warn("before register #{id} handler #{handler.inspect}")
      handler.player_proxy = self
      @sim_connection = handler
      # regiser to player server
      handler.send_object(player_id: id, role: @role)
    end
  end

  def send_message_to_browser message
    if websocket
      Rails.logger.warn("sending to browser #{message}")
      websocket.send_message message[:action], message[:answer]
    else
      Rails.logger.warn("could not send message #{message} to browser as websocket is not yet available")
    end
  end

  module Handler
    include EventMachine::Protocols::ObjectProtocol

    attr_accessor :player_proxy

    def serializer
      JSON
    end

    def receive_object message
      Rails.logger.warn("data received: #{message.inspect}")
      EM.next_tick { player_proxy.send_message_to_browser(message.symbolize_keys!) }
    end

  end

end
