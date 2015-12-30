class BaseEventsController < WebsocketRails::BaseController

  def rescue_block
    yield
  rescue StandardError => exception
    Rails.logger.error exception.message
    #Rails.logger.error exception.backtrace.join('\n')
    raise
  end

  def find_player
    rescue_block do
      @player = find_level.find_player(current_user.id) or raise "no player found for level #{level_id} and user #{current_user.id}"
    end
  end

  def find_level
    level_id = message.delete('level_id')
    level = LevelManager.instance.find(level_id) or raise "level #{level_id} not found"
  end

end
