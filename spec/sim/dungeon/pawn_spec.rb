require 'spec_helper'

describe Dungeon::Pawn do

  let(:pawn) { Dungeon::Pawn.build x: 2, y: 3 }

  it "should return json" do
    pawn.id = 123
    expect(pawn.as_json).to be == {pawn_id: 123, type: 'Dungeon::Pawn' }
  end

end
