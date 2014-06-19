class PlayerProxy
  #include Sim::Popen::MessageSerializer

  attr_accessor :id

  def initialize connection
    @id = UUID.new.generate
    @old_connection = connection # FIXME tmp!
    #connect_to_players_server
  end

  def action action, params = nil
    Rails.logger.warn "send player action #{action} with #{params.inspect}"
    @old_connection.send_player_action id, action, params
  end

  def old_connect_to_players_server
    Rails.logger.warn("connecting to player server...")
    @socket = UNIXSocket.new Rails.root.join('tmp', 'sockets', 'players.sock').to_s
    self.input, self.output = @socket, @socket
    Rails.logger.warn("before register #{id}")
    send_data(player_id: id)
    answer = receive_data
    Rails.logger.warn("after register #{answer}")
  rescue Errno::ENOTSOCK
    raise "sim server is not running"
  end

  def connect_to_players_server
    Rails.logger.warn("connecting to player server...")
    EM.connect_unix_domain(Rails.root.join('tmp', 'sockets', 'players.sock').to_s, PlayerProxy::Handler) do |handler|
      Rails.logger.warn("before register #{id}")
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
    end

  end

end
