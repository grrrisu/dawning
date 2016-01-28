require 'spec_helper'

describe Dungeon::Leopard do

  let(:config)  { {data_file: 'default/jungle_dungeon.json'} }
  let(:builder) { Builder::Dungeon.new(config)}
  let(:dungeon) { builder.create }
  let(:leopard) { dungeon.animals.values.first }

  describe 'search_prey', focus: true do

    it "should not see a pawn" do
      expect(leopard.search_prey(dungeon.map)).to be_nil
    end

    it "should see a pawn" do
      dungeon.map.move leopard, to: [10, 10]
      expect(leopard.search_prey(dungeon.map)).to be_nil
    end

  end

end
