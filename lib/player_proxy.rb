# proxy to player on sim
# holds connection to player server and the websocket connection to the browser
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
    EM.connect_unix_domain(Rails.root.join('tmp', 'sockets', 'players.sock').to_s, Handler) do |handler|
      Rails.logger.warn("before register #{id} handler #{handler.inspect}")
      handler.player_proxy = self
      handler.send_object(player_id: id)
    end
  end

  def send_message_to_browser message
    if websocket
      websocket.send_message :new_message, { user_name: 'system', received: Time.now.to_s(:short), msg_body: message.to_s }
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
      EM.next_tick { send_object message: 'thanks!' }
      EM.next_tick { player_proxy.send_message_to_browser(message) }
    end

  end

end
