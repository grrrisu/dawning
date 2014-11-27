class Admin::Api::V1::LevelsController < ApplicationController

  authorize_resource

  before_filter :find_level, only: [:show, :run, :build, :join, :stop, :destroy]

  respond_to :json

  def index
    data = LevelProxy.levels.map(&:as_json)
    respond_with data
  end

  def show
    render json: @level.as_json
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

  def join
    @level.add_player current_user.id, role: :admin unless @level.find_player(current_user.id)
    render json: {success: true}
  end

private

  def find_level
    unless @level = LevelProxy.find(params[:id])
      render json: {error: "Level with id #{params[:id]} not found"}, status: 404
    end
  end

end
