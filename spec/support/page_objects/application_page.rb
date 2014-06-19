require 'spec_helper'

class ApplicationPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_home
    visit '/'
  end

end
