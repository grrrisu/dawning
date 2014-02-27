require 'spec_helper'

describe World do

  let(:world)   { World.new(15, 30) }

  describe "world bounderies" do

    it "should check bounderies" do
      expect(world.check_bounderies(0, 0)).to be == [0,0]
      expect(world.check_bounderies(15, 30)).to be == [0, 0]
      expect(world.check_bounderies(5, 10)).to be == [5, 10]
      expect(world.check_bounderies(-5, -10)).to be == [14, 29]
      expect(world.check_bounderies(25, 50)).to be == [0, 0]
    end

    it "should check bounderies" do
      expect(world.around_position(0, 0)).to be == [0,0]
      expect(world.around_position(15, 30)).to be == [0, 0]
      expect(world.around_position(5, 10)).to be == [5, 10]
      expect(world.around_position(-5, -10)).to be == [10, 20]
      expect(world.around_position(25, 50)).to be == [10, 20]
      expect(world.around_position(85, 170)).to be == [10, 20]
      expect(world.around_position(-85, -170)).to be == [5, 10]
    end

    it "should set and get values outside the world bounderies" do
      world[25, 50] = 'outside is inside'
      expect(world[25, 50]).to be == 'outside is inside'
    end

  end

end
