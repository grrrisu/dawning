class Admin::LevelsController < ApplicationController

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

  def create_level
    @connection  = Sim::Popen::ParentConnection.new
    sim_library = File.expand_path('../../support/popen_test_level.rb', __FILE__)
    level_class = 'PopenTestLevel'
    config_file = File.expand_path('../../level.yml', __FILE__)
    @connection.start(sim_library, level_class, config_file)
  end

end
