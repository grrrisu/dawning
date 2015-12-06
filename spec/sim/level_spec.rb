require 'spec_helper'

describe Level do

  subject(:level) { Level.instance }

  it "should create the world" do
    config = {world: {height: 100, width: 50}}
    allow(Builder::World).to receive_message_chain(:new, :create) # prevent building for this test
    level.create(config)
    expect(level.world.size).to eq([50, 100])
  end

  it "should create a dungeon" do
    config = {dungeon: {data_file: 'test/dungeon_data.json'}}
    level.create_dungeon(config)
    expect(level.dungeon.size).to eq([5,5])
  end

end
