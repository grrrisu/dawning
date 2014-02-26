require 'spec_helper'

describe Builder::World do

  let(:world)   { World.new(15, 30) }
  let(:config)  { Sim::Buildable.load_config(File.join(Rails.root, 'config', 'levels', 'test.yml'))[:world][:builder] }
  let(:builder) { Builder::World.new(world) }

  it "should create a vegetation" do
    world = builder.create(config)
    world.each_field do |field|
      expect(field.vegetation?).to be_true
    end
  end

  describe "world bounderies" do

    it "should check bounderies" do
      expect(world.check_bounderies(0, 0)).to be == [0,0]
      expect(world.check_bounderies(15, 30)).to be == [0, 0]
      expect(world.check_bounderies(5, 10)).to be == [5, 10]
      expect(world.check_bounderies(-5, -10)).to be == [14, 29]
      expect(world.check_bounderies(25, 50)).to be == [0, 0]
    end

    it "should check bounderies", skip: true do
      expect(world.position_bounderies(0, 0)).to be == [0,0]
      expect(world.position_bounderies(15, 30)).to be == [0, 0]
      expect(world.position_bounderies(5, 10)).to be == [5, 10]
      expect(world.position_bounderies(-5, -10)).to be == [10, 20]
      expect(world.position_bounderies(25, 50)).to be == [10, 20]
    end

  end

end
