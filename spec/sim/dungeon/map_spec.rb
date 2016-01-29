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

  it "should return an array ready for json", skip: true do
    json_data = JSON.load File.open(Rails.root.join('spec', 'fixtures', 'jungle_dungeon.json'))
    json_map  = dungeon.map.as_json
    expect(json_data['fields']).to be == json_map.fields
  end

  describe 'ray_cast' do

    it "should return only fields visible from a position" do
      visible_fields = []
      dungeon.map.ray_cast(x: 12, y: 12, radius: 4) do |x,y|
        expect { dungeon.map[x, y] }.to_not raise_error
        visible_fields << [x,y]
      end
      expect(visible_fields.count).to be == 37
    end

    it "should ignore fields beyond world border" do
      visible_fields = []
      dungeon.map.ray_cast(x: 23, y: 22, radius: 4) do |x,y|
        expect { dungeon.map[x, y] }.to_not raise_error
        visible_fields << [x,y]
      end
      expect(visible_fields.count).to be == 21
    end

  end

  describe 'move' do

    it "should move thing to another position" do
      animal = dungeon.animals.values.first
      expect(animal.x).to be 22
      expect(animal.y).to be 8

      dungeon.map.move animal, to: [12, 12]
      expect(dungeon.map[ 8, 22]).to_not include(animal)
      expect(dungeon.map[12, 12]).to include(animal)
      expect(animal.x).to be 12
      expect(animal.y).to be 12
    end

  end

end
