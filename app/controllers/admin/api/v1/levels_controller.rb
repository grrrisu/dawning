class Admin::Api::V1::LevelsController < ApplicationController

  authorize_resource

  before_filter :find_level, only: [:show, :run, :build, :join, :stop, :destroy, :objects_count, :terminal_command]

  respond_to :json

  def index
    data = LevelManager.instance.levels.map(&:as_json)
    respond_with data
  end

  def show
    render json: @level.as_json
  end

  def create
    level = LevelManager.instance.create params[:level][:name]
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

  def objects_count
    render json: @level.objects_count
  end

  def terminal_command
    render json: {answer: @level.terminal_command(params[:command])}
  end

private

  def find_level
    unless @level = LevelManager.instance.find(params[:id])
      render json: {error: "Level with id #{params[:id]} not found"}, status: 404
    end
  end

end
