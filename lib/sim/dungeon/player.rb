class Dungeon
  class Player

    attr_reader :user
    attr_accessor :food_points

    def initialize user
      @user = user
    end

    def save_points
      if user.points < food_points
        user.update_attribute(:points, food_points)
      end
    end

  end
end
