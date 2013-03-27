class Admin::LevelsController < ApplicationController

  def index
    authorize! :index, Level
  end

  def create
    authorize! :create, Level
    # TODO
    redirect_to admin_levels_path, flash: {notice: 'Level has been created'}
  end

end
