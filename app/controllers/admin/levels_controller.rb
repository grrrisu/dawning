class Admin::LevelsController < ApplicationController
  navigation :admin, :levels

  before_filter :find_level, only: [:run, :join, :build, :stop, :destroy]

  def index
    authorize! :index, LevelProxy
    @levels = LevelProxy.levels
  end

  def create
    authorize! :create, LevelProxy
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

  def join
    authorize! :admin_join, @level
    @level.add_player current_user.id, role: :admin unless @level.find_player(current_user.id)
    redirect_to level_map_path(@level.id)
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
