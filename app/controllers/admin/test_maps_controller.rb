class Admin::TestMapsController < ApplicationController
  navigation :admin, :test_map

  before_filter :get_level

  def show
    authorize! :show, 'TestMap'
    render template: '/maps/show'
  end

  def update
    authorize! :field_update, 'TestMap'
    @level.player.send_message 'update_view', message: nil
    render nothing: true
  end

private

  def get_level
    unless @level = LevelManager.instance.find(Test::LevelProxy::ID)
      @level = Test::LevelProxy.new
    end
  end

end
