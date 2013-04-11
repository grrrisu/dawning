require 'spec_helper'

describe Ability do

  let(:level) { LevelProxy.new(UUID.new.generate, 'test level') }

  describe 'role admin' do
    subject { create :admin_user }
    it { should have_ability_to :index, Level}
    it { should have_ability_to :create, Level}
    it { should have_ability_to :build, level }
    it { should have_ability_to :run, level }
    it { should have_ability_to :stop, level }
    it { should have_ability_to :destory, level }
  end

  describe 'role member' do
    subject { create :user }
    it { should_not have_ability_to :index, Level }
    it { should_not have_ability_to :create, Level }
    it { should_not have_ability_to :build, level }
    it { should_not have_ability_to :run, level }
    it { should_not have_ability_to :stop, level }
    it { should_not have_ability_to :destory, level }
  end

  describe 'role guest' do
    subject { User.new }
    it { should_not have_ability_to :index, Level }
    it { should_not have_ability_to :create, Level }
    it { should_not have_ability_to :build, level }
    it { should_not have_ability_to :run, level }
    it { should_not have_ability_to :stop, level }
    it { should_not have_ability_to :destory, level }
  end

end
