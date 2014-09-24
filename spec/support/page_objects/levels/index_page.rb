module Levels
  class IndexPage < ApplicationPage

    def open
      visit levels_path
    end

    def entry level
      find("#level_#{level.id}")
    end

    def join level
      within(entry(level)) do
        click_link "join_#{level.id}"
      end
    end

    def enter level
      within(entry(level)) do
        click_link "enter_#{level.id}"
      end
    end

  end
end
