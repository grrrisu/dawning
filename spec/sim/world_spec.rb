require 'spec_helper'

describe World do

  let(:world) { World.new(3,3) }

  it "should print world" do
    expect(world).to receive(:puts).with(including('0 0'))
    world.pp
  end

end
