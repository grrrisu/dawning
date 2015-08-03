class Admin::TestMapsController < ApplicationController

  before_filter :get_level

  def update_view
    authorize! :field_update, 'TestMap'
    @level.player.send_message 'update_view', message: nil
    render nothing: true
  end

private

  def get_level
    @level = LevelProxy.find(Test::LevelProxy::ID)
  end

end
