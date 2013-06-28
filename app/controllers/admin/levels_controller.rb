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
    authorize! :run, @level
    @level.start
    flash[:notice] = "Level #{@level.name} is running"
    render action: :level
  end

  def build
    authorize! :build, @level
    @level.build params[:config_file]
    flash[:notice] = "Level #{@level.name} has been built"
    render action: :level
  end

  def stop
    authorize! :stop, @level
    @level.stop
    flash[:notice] = "Level #{@level.name} has been stopped"
    render action: :level
  end

  def destroy
    authorize! :destroy, @level
    @level.remove
    flash[:notice] = "Level #{@level.name} has been removed"
    render action: :destroy
  end

private

  def find_level
    @level =  LevelProxy.find params[:id]
  end

end
