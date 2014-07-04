class MapEventsController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  before_filter :find_player #, only: [:init_map]

  def client_connected
    Rails.logger.warn("client connected to websocket")
  end

  def client_disconnected
    Rails.logger.warn("client disconnected from websocket")
  end

  def init_map
    rescue_block do
      Rails.logger.warn 'sending init_map ...'
      @player.websocket = connection
      @player.send_message 'init_map'
    end
  end

  def view
    rescue_block do
      Rails.logger.warn "sending view ... #{message}"
      @player.send_message 'view', message
    end
  end

  def move
    rescue_block do
      Rails.logger.warn "sending move ... #{message}"
      @player.send_message 'move', message
    end
  end

  def find_player
    rescue_block do
      level_id = message.delete('level_id')
      @player = LevelProxy.find(level_id).try(:find_player, current_user.id) or raise "no player found for level #{params[:level_id]} and user #{current_user}"
    end
  end

  def rescue_block
    yield
  rescue Exception => exception
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join('\n')
  end

end
