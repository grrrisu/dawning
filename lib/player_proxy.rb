class PlayerProxy

  attr_accessor :id

  def initialize connection
    @id = UUID.new.generate
    @connection = connection # FIXME tmp!
  end

  def action action, params = nil
    Rails.logger.warn "send player action #{action} with #{params.inspect}"
    @connection.send_player_action id, action, params
  end

end
