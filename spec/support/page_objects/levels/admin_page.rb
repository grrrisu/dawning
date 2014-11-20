module Levels
  class AdminPage < ApplicationPage

    def open
      visit admin_launch_panel_path
    end

  end
end
