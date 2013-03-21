FactoryGirl.define do
  
  factory :authentication do
    user
    provider    'github'
    uid         1234567890
  end
  
  
  # --- User ---

  factory :pending_user, class: User do
    username  { generate :username }
    email     {|u| "#{u.username.gsub(' ', '_')}@example.com"}
    password  "Sesame"
    password_confirmation {|u| u.password}
    role      "member"
    after(:create) {|u| u.password_confirmation = nil }
  end
  
  factory :user, parent: :pending_user do
    after(:create) do |user|
      user.activate!
      # remove confirm_registration and activation mails
      ActionMailer::Base.deliveries.pop(2)
    end
  end
  
  factory :admin_user, parent: :user do
    role 'admin'
  end

end