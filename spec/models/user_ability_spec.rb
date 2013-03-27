require 'spec_helper'

describe Ability do

  describe 'role admin' do
    before :each do
      @admin = FactoryGirl.create :admin_user
    end

    it "should be able to manage users" do
      user = FactoryGirl.create :user
      @admin.should have_ability_to :read, user
      @admin.should have_ability_to :create, User
      @admin.should have_ability_to :update, user
      @admin.should have_ability_to :destroy, user
    end
  end

  describe 'role member' do
    before :each do
      @member = FactoryGirl.create :user
    end

    it "should only be able to update his own user" do
      user = FactoryGirl.create :user
      @member.should have_ability_to :read, user
      @member.should have_ability_to :update, @member

      @member.should_not have_ability_to :create, User
      @member.should_not have_ability_to :update, user
      @member.should_not have_ability_to :destroy, user
      @member.should_not have_ability_to :destroy, @member
    end
  end

  describe 'role guest' do

    before :each do
      @guest = User.new
    end

    it "should be able to register" do
      user = FactoryGirl.create :user
      @guest.should have_ability_to :read, User
      @guest.should have_ability_to :create, User

      @guest.should_not have_ability_to :update, user
      @guest.should_not have_ability_to :destroy, user
    end

  end

end
