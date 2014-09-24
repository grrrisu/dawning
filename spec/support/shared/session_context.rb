RSpec.shared_context "session" do

  let(:member_user) { create :user, password: 'secret' }
  let(:admin_user)  { create :admin_user, password: 'secret' }
  let(:login_page)  { Sessions::LoginPage.new }

  def login_with(username, password)
    login_page.open
    login_page.fill_form_with username: username, password: password
    login_page.submit
  end

  def logged_in_user
    login_with(member_user.username, 'secret')
    member_user
  end

  def logged_in_admin
    login_with(admin_user.username, 'secret')
    admin_user
  end

end
