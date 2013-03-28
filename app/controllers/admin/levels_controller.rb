class Admin::LevelsController < ApplicationController
  navigation :admin, :levels

  def index
    authorize! :index, Level
    @levels = LevelProxy.levels
  end

  def create
    authorize! :create, Level
    if params[:level].try(:[],:name)
      LevelProxy.create params[:level][:name]
    else
      raise ArgumentError, "no name passed"
    end
    redirect_to admin_levels_path, flash: {notice: 'Level has been created'}
  end

end
