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
      @player.send_message 'food_collected', message
    end
  end

  def game_over
    rescue_block do
      logger.info "game over #{message}"
      dungeon.game_over(message, @player)
    end
  end

end
