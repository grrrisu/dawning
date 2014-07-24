require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Headquarter do

  before(:each) do
    @headquarter = Headquarter.build(x: 5, y: 5)
  end

  describe "create view" do

    before(:each) do
      @headquarter.pawns << Pawn.build(x: 4, y: 5)
      config  = {world: {height: 10, width: 10}}
      world   = World.new(11).build(config)
      @view   = View.new(world, 0, 0, world.width, world.height)
      @view.unfog(@headquarter)
      @headquarter.pawns.each {|pawn| @view.unfog(pawn) }
    end

    it "with size of 11" do
      expect(@view.size).to be == [11,11]
    end

    it "at position 2,2" do
      expect(@view.x).to be == 0
      expect(@view.y).to be == 0
    end

    it "has set visability" do
      expect(@view[2,2]).to be == 0  # outside of any view
      expect(@view[5,5]).to be == 2  # hq & pawn
      expect(@view[6,6]).to be == 1  # only hq
    end

  end

end
