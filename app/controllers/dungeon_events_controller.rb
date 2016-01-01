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

  def attacked
    rescue_block do
      logger.info "attacked #{message}"
      @player.send_message 'attacked', message
    end
  end

  def pawn_moved
    rescue_block do
      logger.info "pawn moved"
      @player.send_message 'dungeon_move', message
    end
  end

end
