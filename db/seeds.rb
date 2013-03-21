unless User.find_by_username('admin')
  admin = User.new(username: 'admin', password: 'admin123', password_confirmation: 'admin123', email: 'info@zero-x.net')
  admin.role = 'admin'
  admin.save!
  admin.activate!
end
