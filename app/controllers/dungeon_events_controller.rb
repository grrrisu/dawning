class DungeonEventsController < BaseEventsController

  def init_dugeon
    rescue_block do
      logger.info 'init_dungeon'
      connection.send_message :init_dungeon, dungeon.fields
    end
  end

  private

  def dungeon
    @dungeon ||= Dungeon.new
  end

end
