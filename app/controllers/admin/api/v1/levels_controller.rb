class Admin::Api::V1::LevelsController < ApplicationController

  authorize_resource

  before_filter :find_level, only: [:run, :build, :stop, :destroy]

  respond_to :json

  def index
    data = LevelProxy.levels.map(&:as_json)
    respond_with data
  end

  def create
    if params[:level].try(:[],:name)
      level = LevelProxy.create params[:level][:name]
      render json: level.as_json
    else
      raise ArgumentError, "no name passed"
    end
  end

  def build
    @level.build params[:config_file]
    render action: :level
  end

  def run
    @level.start
    render action: :level
  end

  def stop
    @level.stop
    render action: :level
  end

  def destroy
    @level.remove
    render action: :destroy
  end

private

  def find_level
    @level =  LevelProxy.find params[:id]
  end

end
