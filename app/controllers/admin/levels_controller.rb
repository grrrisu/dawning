class Admin::LevelsController < ApplicationController
  navigation :admin, :levels

  before_filter :find_level, only: [:run, :build, :stop, :destroy]

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

  def run
    @level.start
    authorize! :run, @level
    render action: :level
  end

  def build
    @level.create
    authorize! :build, @level
    render action: :level
  end

  def stop
    @level.stop
    authorize! :stop, @level
    render action: :level
  end

  def destroy
    @level.remove
    authorize! :destroy, @level
    render action: :destroy
  end

private

  def find_level
    @level =  LevelProxy.find params[:id]
  end

end
