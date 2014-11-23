class Admin::Api::V1::ConfigFilesController < ApplicationController

  respond_to :json

  def index
    authorize! :index, 'ConfigFiles'
    config_files = Dir.glob(Rails.root.join('config', 'levels', '*.yml'))
    config_files = config_files.map {|config_file| config_file.split('/').last }
    respond_with config_files
  end

end
