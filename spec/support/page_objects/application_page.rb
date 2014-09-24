class ApplicationPage
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def open
    visit '/'
    self
  end

  def flash
    find('.alert-box')
  end

  def navigation
    find('nav.navbar')
  end

  def click_nav_register
    click_nav 'register'
  end

  def click_nav_login
    click_nav 'login'
  end

  def click_nav_logout
    click_nav 'logout'
  end

  def email_sent
    ActionMailer::Base.deliveries.first
  end

  def emails_sent
    ActionMailer::Base.deliveries
  end

  def visit_link_in_email index = 0
    email = ActionMailer::Base.deliveries[index]
    link  = email.body.match /http:\/\/.*?(\/.*?)$/
    visit link[1]
  end

private

  def click_nav identifier
    within navigation do
      click_link identifier
    end
  end

end
