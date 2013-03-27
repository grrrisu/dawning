class Admin::LevelsController < ApplicationController

  def index
    authorize! :index, Level
  end

end
