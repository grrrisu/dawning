class PlayerProxy

  attr_accessor :id
  attr_accessor :websocket

  def initialize connection
    @id = UUID.new.generate
    @old_connection = connection # FIXME tmp!
    connect_to_players_server
  end

  def action action, params = nil
    Rails.logger.warn "send player action #{action} with #{params.inspect}"
    @old_connection.send_player_action id, action, params
  end

  def connect_to_players_server
    Rails.logger.warn("connecting to player server...")
    EM.connect_unix_domain(Rails.root.join('tmp', 'sockets', 'players.sock').to_s, PlayerProxy::Handler) do |handler|
      Rails.logger.warn("before register #{id} handler #{handler.inspect}")
      handler.send_object(player_id: id)
    end
  end

  # EM specific

  module Handler
    include EventMachine::Protocols::ObjectProtocol

    def serializer
      JSON
    end

    def receive_object message
      Rails.logger.warn("data received: #{message.inspect}")
      EM.next_tick { send_object message: 'thanks!' }
    end

  end

end
