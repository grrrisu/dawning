require 'spec_helper'

describe Builder::Dungeon do

  let(:config)  { {data_file: 'test/dungeon_data.json'} }
  let(:builder) { Builder::Dungeon.new(config) }

  it "should create a dungeon" do
    expect(builder.create).to be_instance_of(::Dungeon)
  end

  it "should load data" do
    builder.dungeon = ::Dungeon.new
    builder.load_data 'test/dungeon_data.json'
    expect(builder.dungeon.size).to be == [5,5]
  end

end
