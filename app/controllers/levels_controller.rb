class LevelsController < ApplicationController
  navigation :levels

  before_filter :find_level, only: [:join, :continue, :leave]

  def index
    authorize! :index, LevelProxy
    @levels = LevelProxy.levels
  end

  def join
    authorize! :join, @level
    @level.add_player current_user.id
    redirect_to levels_path
  end

  def continue

  end

  def leave
    @level.remove_player current_user.id
  end

private

  def find_level
    @level =  LevelProxy.find params[:id]
  end

end
