class LevelsController < ApplicationController
  navigation :levels

  #before_filter :find_level, only: [:run, :build, :stop, :destroy]

  def index
    authorize! :index, Level
    @levels = LevelProxy.levels
  end

private

  def find_level
    @level =  LevelProxy.find params[:id]
  end

end
