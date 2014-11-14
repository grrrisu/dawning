class Admin::Api::V1::LevelsController < ApplicationController

  respond_to :json

  def index
    authorize! :index, LevelProxy
    data = LevelProxy.levels.map do |level|
      json = { id: level.id, name: level.name, state: level.state, config_file: level.config_file }
      unless level.state == :stopped
        json.merge! level.as_json
      end
      json
    end
    respond_with data
  end

end
