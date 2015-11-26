require 'spec_helper'

describe Dungeon::Player do

  let(:user)    { User.new }
  let(:player)  { Dungeon::Player.new(user) }

  it "should save points if achieved more food_points" do
    user.points = 20
    player.food_points = 50
    player.save_points
    expect(user.points).to be == 50
  end

  it "should not save points if achieved less food_points" do
    user.points = 70
    player.food_points = 50
    player.save_points
    expect(user.points).to be == 70
  end

end
