require 'spec_helper'

describe Builder::Dungeon do

  let(:config)  { {data_file: 'test/dungeon_data.json'} }
  let(:builder) { Builder::Dungeon.new(config) }

  it "should create a dungeon" do
    expect(builder.create).to be_instance_of(::Dungeon::Actor)
  end

  it "should load data" do
    builder.dungeon = ::Dungeon::Actor.new
    builder.load_data 'test/dungeon_data.json'
    expect(builder.dungeon.map.size).to be == [5,5]
  end

  describe 'create' do

    let (:dungeon) { builder.create }

    it "should leave an empty array" do
      free = dungeon.map[2,0]
      expect(free).to be_empty
    end

    it "should create a tree" do
      tree = dungeon.map[0,0].first
      expect(tree.blocks_visability).to be true
    end

    it "should create a bush" do
      tree = dungeon.map[1,0].first
      expect(tree.blocks_visability).to be false
    end

    it "should create a fruit" do
      fruit = dungeon.map[2,1].first
      expect(fruit.capacity).to be == ::Dungeon::Fruit::Banana2
    end

    it "should create a rabbit" do
      rabbit = dungeon.map[1,3].first
      expect(rabbit).to be_instance_of(::Dungeon::Rabbit)
    end

    it "should create a leopard" do
      leopard = dungeon.map[2,3].first
      expect(leopard).to be_instance_of(::Dungeon::Leopard)
    end

  end

end
