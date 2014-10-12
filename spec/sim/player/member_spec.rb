require 'spec_helper'

describe Player::Member do

  let(:world)       { World.new(3,3) }
  let(:view)        { View.new(world, 0, 0, world.height)}
  let(:headquarter) { Headquarter.build(x: 1, y: 1) }
  let(:player)      { Player::Member.new('123', double(:level)) }

  describe 'move' do

    before :each do
      world[1,1].pawn = headquarter
      headquarter.pawns << @pawn = Pawn.build(x: 0, y: 1)
      world[0,1].pawn = @pawn
      player.place(view, headquarter)
    end

    it "should move pawn to an empty field" do
      expect(player.move(@pawn.id, 0, 0)).to be == Hashie::Mash.new(pawn_id: @pawn.id, x: 0, y: 0, notify: {x: 0, y:0, height: 2, width: 1})
    end

    it "should not move a pawn to an occupied field" do
      expect(player.move(@pawn.id, 1, 1)).to be == Hashie::Mash.new(pawn_id: @pawn.id, x: 0, y: 1)
    end

  end

end
