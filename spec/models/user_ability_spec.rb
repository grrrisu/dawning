require 'spec_helper'

describe Ability do

  let(:user) { FactoryGirl.create :user }

  describe 'role admin' do
    subject(:admin) { FactoryGirl.create :admin_user }
    it { should have_ability_to :read, user }
    it { should have_ability_to :create, User }
    it { should have_ability_to :update, user }
    it { should have_ability_to :destroy, user }
  end

  describe 'role member' do
    subject(:member) { FactoryGirl.create :user }
    it { should have_ability_to :read, user }
    it { should have_ability_to :update, member }
    it { should_not have_ability_to :create, User }
    it { should_not have_ability_to :update, user }
    it { should_not have_ability_to :destroy, user }
    it { should_not have_ability_to :destroy, member }
  end

  describe 'role guest' do
    subject(:guest) { User.new }
    it { should have_ability_to :read, User }
    it { should have_ability_to :create, User }
    it { should_not have_ability_to :update, user }
    it { should_not have_ability_to :destroy, user }
  end

end
