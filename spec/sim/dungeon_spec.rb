require 'spec_helper'

describe Dungeon do

  let(:dungeon) { Dungeon.new.load }

  it "should return fields" do
    expect(dungeon.fields).to be_instance_of Array
  end

  it "should return food points at position" do
    expect(dungeon.food_points_at(1,1)).to be == Dungeon::Banana2
  end

  it "should calculate total food_points" do
    expect(dungeon.total_food_points).to be == 750
  end

  it "should convert an iso position on the data map" do
    expect(dungeon.map_position(121, 66)).to be == [1,1]
  end

  it "should reset dungeon", focus: true do
    dungeon[1,1] = '0'
    player = Dungeon::Player.new(User.new(id: 123))
    dungeon.add_player(player)
    player.food_points = 20

    expect(dungeon[1,1]).to be == '0'
    expect(dungeon.find_player(123).food_points).to be == 20
    dungeon.reset
    expect(dungeon[1,1]).to be == '2'
    expect(dungeon.find_player(123).food_points).to be == 0
  end

end
