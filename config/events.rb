WebsocketRails::EventMap.describe do

  subscribe :client_connected,    to: MapEventsController, with_method: :client_connected
  subscribe :client_disconnected, to: MapEventsController, with_method: :client_disconnected

  subscribe :init_map,            to: MapEventsController, with_method: :init_map
  subscribe :view,                to: MapEventsController, with_method: :view
  subscribe :move,                to: MapEventsController, with_method: :move

  subscribe :new_message,         to: ChatController, with_method: :new_message
  subscribe :new_user,            to: ChatController, with_method: :new_user
  #subscribe :change_username,     to: ChatController, with_method: :change_username

end
