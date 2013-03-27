require 'spec_helper'

describe Ability do

  describe 'role admin' do
    before :each do
      @admin = FactoryGirl.create :admin_user
    end

    it "should be able to manage levels" do
      @admin.should have_ability_to :index, Level
      # @admin.should have_ability_to :create, User
      # @admin.should have_ability_to :update, user
      # @admin.should have_ability_to :destroy, user
    end
  end

  describe 'role member' do
    before :each do
      @member = FactoryGirl.create :user
    end

    it "should not be able to manage levels" do
      @member.should_not have_ability_to :index, Level
    end
  end

  describe 'role guest' do

    before :each do
      @guest = User.new
    end

    it "should not be able to manage levels" do
      @guest.should_not have_ability_to :index, Level
    end

  end

end
