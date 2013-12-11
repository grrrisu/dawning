unless User.find_by_username('Rocky 1')
  20.times do |n|
    user = User.new(username: "Rocky #{n+1}", password: 'rocky', password_confirmation: 'rocky', email: "rocky#{n+1}@example.com")
    user.save!
    user.activate!
  end
end
