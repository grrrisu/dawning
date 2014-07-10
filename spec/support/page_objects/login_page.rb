require 'spec_helper'

class LoginPage < ApplicationPage

  def visit
    visit login_path
    self
  end

end
