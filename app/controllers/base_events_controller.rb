class BaseEventsController < WebsocketRails::BaseController

  def rescue_block
    yield
  rescue Exception => exception
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join('\n')
  end

end
