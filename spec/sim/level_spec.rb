require 'spec_helper'

describe Level do

  subject(:level) { Level.new }

  it "should create the world" do
    config = {'world' => {'height' => 100, 'width' => 50}}
    level.create(config)
    level.world.size.should == [50, 100]
  end

end
