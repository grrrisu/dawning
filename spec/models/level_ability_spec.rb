require 'spec_helper'

describe Ability do

  let(:level) { LevelProxy.new(UUID.new.generate, 'test level') }

  describe 'role admin' do
    subject { create :admin_user }
    it { should have_ability_to :index, LevelProxy}
    it { should have_ability_to :create, LevelProxy}
    it { should have_ability_to :build, level }
    it { should have_ability_to :run, level }
    it { should have_ability_to :stop, level }
    it { should have_ability_to :destory, level }
    it { should have_ability_to :join, level }
    it { should have_ability_to :init, level }
  end

  describe 'role member' do
    subject { create :user }
    it { should have_ability_to :index, LevelProxy }
    it { should_not have_ability_to :create, LevelProxy }
    it { should_not have_ability_to :build, level }
    it { should_not have_ability_to :run, level }
    it { should_not have_ability_to :stop, level }
    it { should_not have_ability_to :destory, level }
    it { should have_ability_to :join, level }
    it { should_not have_ability_to :init, level }
    it { should_not have_ability_to :view, level }
    it { should_not have_ability_to :move, level }

    describe 'has joined a level' do
      before(:each) { level.players[subject.id] = 123 }
      it { should have_ability_to :init, level }
      it { should have_ability_to :view, level }
      it { should have_ability_to :move, level }
    end
  end

  describe 'role guest' do
    subject { User.new }
    it { should_not have_ability_to :index, LevelProxy }
    it { should_not have_ability_to :create, LevelProxy }
    it { should_not have_ability_to :build, level }
    it { should_not have_ability_to :run, level }
    it { should_not have_ability_to :stop, level }
    it { should_not have_ability_to :destory, level }
    it { should_not have_ability_to :join, level }
    it { should_not have_ability_to :init, level }
  end

end
