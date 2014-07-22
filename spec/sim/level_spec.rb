require 'spec_helper'

describe Level do

  subject(:level) { Level.new }

  it "should create the world" do
    config = {world: {height: 100, width: 50}}
    allow(Builder::World).to receive_message_chain(:new, :create) # prevent building for this test
    level.create(config)
    expect(level.world.size).to eq([50, 100])
  end

end
