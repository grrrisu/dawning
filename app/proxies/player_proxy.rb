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

  # callback for incoming player messages from the sim container
  #
  # ignores register message {:player_id=>"123", :registered=>true}
  def message_received message
    if message[:action]
      Rails.logger.debug("sending #{message[:action]} to browser")
      websocket.send_message message[:action], message[:answer]
      process_return_message message
    end
  end

  def update_food_points message
    user.save_points message['food_points']
  end

  def dungeon_end message
    user.save_points message['food_points']
  end

private

  def process_return_message message
    if respond_to?(message[:action].to_sym)
      send message[:action], message[:answer]
    end
  end

  def allowed_role role
    case role
      when :admin then user.admin? ? :admin : :player
      else :player
    end
  end

end
