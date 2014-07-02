WebsocketRails::EventMap.describe do
  subscribe :client_connected,    to: ChatController, with_method: :client_connected
  subscribe :new_message,         to: ChatController, with_method: :new_message
  subscribe :new_user,            to: ChatController, with_method: :new_user
  subscribe :change_username,     to: ChatController, with_method: :change_username
  subscribe :client_disconnected, to: ChatController, with_method: :delete_user

  subscribe :init_map,            to: MapEventsController, with_method: :init_map
  subscribe :view,                to: MapEventsController, with_method: :view
  subscribe :move,                to: MapEventsController, with_method: :move

end
