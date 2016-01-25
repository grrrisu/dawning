WebsocketRails::EventMap.describe do

  subscribe :client_connected,    to: ChatController, with_method: :client_connected
  subscribe :client_disconnected, to: ChatController, with_method: :client_disconnected
  subscribe :new_message,         to: ChatController, with_method: :new_message

  subscribe :init_map,            to: MapEventsController, with_method: :init_map
  subscribe :view,                to: MapEventsController, with_method: :view
  subscribe :move,                to: MapEventsController, with_method: :move
  subscribe :update_view,         to: MapEventsController, with_method: :update_view

  subscribe :init_dungeon,        to: DungeonEventsController, with_method: :init_dungeon
  subscribe :pawn_moved,          to: DungeonEventsController, with_method: :pawn_moved
  subscribe :animal_moved,        to: DungeonEventsController, with_method: :animal_moved
  subscribe :food_collected,      to: DungeonEventsController, with_method: :food_collected
  subscribe :attacked,            to: DungeonEventsController, with_method: :attacked

end
