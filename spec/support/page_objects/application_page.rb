class ApplicationPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit_home
    visit '/'
  end

  def has_success_alert? text
    within('.alert-success') do
      has_content? text
    end
  end

  def has_error_alert? text
    within('.alert-danger') do
      has_content? text
    end
  end

  # navigation

  def logout
    click_link 'logout'
  end

end
