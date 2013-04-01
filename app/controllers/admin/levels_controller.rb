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
      level = LevelProxy.create params[:level][:name]
    else
      raise ArgumentError, "no name passed"
    end
    redirect_to admin_levels_path, flash: {notice: "Level #{level.name} has been launched"}
  end

  def run
    @level.start
    authorize! :run, @level
    flash[:notice] = "Level #{@level.name} is running"
    render action: :level
  end

  def build
    @level.build
    authorize! :build, @level
    flash[:notice] = "Level #{@level.name} has been built"
    render action: :level
  end

  def stop
    @level.stop
    authorize! :stop, @level
    flash[:notice] = "Level #{@level.name} has been stopped"
    render action: :level
  end

  def destroy
    @level.remove
    authorize! :destroy, @level
    flash[:notice] = "Level #{@level.name} has been removed"
    render action: :destroy
  end

private

  def find_level
    @level =  LevelProxy.find params[:id]
  end

end
