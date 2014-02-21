require 'spec_helper'

describe Player do

  let(:world)       { World.new(3,3) }
  let(:view)        { View.new(world, 0, 0, world.height)}
  let(:headquarter) { Headquarter.new(1,1) }
  let(:player)      { Player.new(view, headquarter) }

  describe 'move', focus: true do

    before :each do
      # FIXME
      world.set_each_field { Sim::FieldProperties.new }
      world[1,1].pawn = headquarter

      headquarter.pawns << @pawn = Pawn.new(0, 1)
      world[0,1].pawn = @pawn
    end

    it "should move pawn to an empty field" do
      expect(player.move(@pawn.id, 0, 0)).to be == {x: 0, y: 0}
    end

    it "should not move a pawn to an occupied field" do
      expect(player.move(@pawn.id, 1, 1)).to be == {x: 0, y: 1}
    end

  end

end
