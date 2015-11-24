class DungeonEventsController < BaseEventsController

  def init_dungeon
    rescue_block do
      logger.info 'init_dungeon'
      connection.send_message :init_dungeon, dungeon.fields
    end
  end

  def food_collected
    rescue_block do
      logger.info "food collected #{message}"
    end
  end

  def game_over
    rescue_block do
      logger.info "game over #{message}"
    end
  end

  private

  def dungeon
    @dungeon ||= Dungeon.new
  end

end
