require 'spec_helper'

describe World do

  let(:world)  { World.new(3,3) }
  let(:object) { Sim::Object.new }

  it "should move pawn" do
    world[1,1][:pawn] = object
    source = world[1,1]
    target = world[1,2]
    world.move(:pawn, source, target)
    expect(world[1,1].pawn).to be_nil
    expect(world[1,2].pawn).to eq(object)
  end

  it "should print world" do
    expect(world).to receive(:puts).with(including('0 0'))
    world.pp
  end

end
