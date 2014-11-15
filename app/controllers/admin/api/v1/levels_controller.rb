class Admin::Api::V1::LevelsController < ApplicationController

  authorize_resource

  before_filter :find_level, only: [:run, :build, :stop, :destroy]

  respond_to :json

  def index
    data = LevelProxy.levels.map(&:as_json)
    respond_with data
  end

  def create
    level = LevelProxy.create params[:level][:name]
    render json: level.as_json
  end

  def build
    @level.build params[:level][:config]
    render json: @level.as_json
  end

  def run
    @level.start
    render json: @level.as_json
  end

  def stop
    @level.stop
    render json: @level.as_json
  end

  def destroy
    @level.remove
    render json: nil
  end

private

  def find_level
    @level =  LevelProxy.find params[:id]
  end

end
