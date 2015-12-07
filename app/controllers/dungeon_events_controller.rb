class DungeonEventsController < BaseEventsController

  before_filter :find_player

  def init_dungeon
    rescue_block do
      logger.info 'init_dungeon'
      @player.websocket = connection
      @player.send_message 'init_dungeon'
    end
  end

  def food_collected
    rescue_block do
      logger.info "food collected #{message}"
      total_food_points = dungeon.food_collected(message, @player)
      connection.send_message :food_collected, total_food_points
    end
  end

  def game_over
    rescue_block do
      logger.info "game over #{message}"
      dungeon.game_over(message, @player)
    end
  end

  private

  def find_player
    rescue_block do
      level_id = message.delete('level_id')
      @player = LevelManager.instance.find(level_id).try(:find_player, current_user.id) or raise "no player found for level #{level_id} and user #{current_user.id}"
    end
  end

  def dungeon
    @dungeon ||= Dungeon.instance
  end

  def get_player
    rescue_block do
      unless @player = dungeon.find_player(current_user.id)
        @player = Dungeon::Player.new(current_user)
        dungeon.add_player(@player)
      end
    end
  end

end
