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
    json = JSON.load(File.read(Rails.root.join('spec', 'fixtures', 'init_map.json')))
    receive_message action: 'init_map', answer: json
  end

  def view message
    json = JSON.load(File.read(Rails.root.join('spec', 'fixtures', 'view.json')))
    receive_message action: 'view', answer: json
  end

  def move message
  end

end
