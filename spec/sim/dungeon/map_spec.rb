require 'spec_helper'

describe Dungeon::Map do

  let(:level)   { Level.instance }
  let(:config)  { {data_file: 'default/jungle_dungeon.json'} }
  let(:builder) { Builder::Dungeon.new(config)}
  let(:dungeon) { builder.create }

  it "should return fields" do
    expect(dungeon.map.fields).to be_instance_of Array
  end

  it "should return food points at position" do
    expect(dungeon.map.food_points_at(1,1)).to be == Dungeon::Fruit::Banana2
  end

  it "should calculate total food_points" do
    expect(dungeon.map.total_food_points).to be == 750
  end

  it "should convert an iso position on the data map" do
    expect(dungeon.map.position(121, 66)).to be == [1,1]
  end

  it "should return an array ready for json" do
    json_data = JSON.load File.open(Rails.root.join('config', 'levels', 'default', 'jungle_dungeon.json'))
    json_map  = dungeon.map.as_json
    expect(json_data['fields']).to be == json_map.fields
  end

end
