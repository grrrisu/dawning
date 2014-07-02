class MapEventsController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  before_filter :find_player #, only: [:init_map]

  def init_map
    Rails.logger.warn 'sending init_map ...'
    @player.websocket = connection
    @player.send_message 'init_map'
  rescue Exception => exception
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join('\n')
  end

  def find_player
    @player = LevelProxy.find(message['level_id']).try(:find_player, current_user.id) or raise "no player found for level #{params[:level_id]} and user #{current_user}"
  rescue Exception => exception
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join('\n')
  end

end
