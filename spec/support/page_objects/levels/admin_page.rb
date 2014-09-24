module Levels
  class AdminPage < ApplicationPage

    def open
      visit admin_levels_path
    end

  end
end
