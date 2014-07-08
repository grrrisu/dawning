class BasePlayer < Sim::Player

  def direct_actions
    [:init_map, :view]
  end

end
