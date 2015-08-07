class Test::PlayerProxy

  attr_accessor :websocket

  def send_message action, message = nil
    send(action, message)
  end

  def receive_message message
    Rails.logger.debug("sending #{message[:action]} to browser")
    websocket.send_message message[:action], message[:answer]
  end

  def init_map message = nil
    # init_map for member or init_map_admin for admin
    json = JSON.load(File.read(Rails.root.join('spec', 'fixtures', 'init_map.json')))
    receive_message action: 'init_map', answer: json
  end

  def view message
    template = Tilt.new Rails.root.join('spec', 'fixtures', 'view.json.erb').to_s
    json = JSON.load template.render(message)
    receive_message action: 'view', answer: json
  end

  def update_view message
    json = JSON.load(File.read(Rails.root.join('spec', 'fixtures', 'update_view.json')))
    receive_message action: 'update_view', answer: json
  end

  def move message
    receive_message action: 'move', answer: message
  end

end
