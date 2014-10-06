require 'spec_helper'

describe Builder::World do

  let(:world)   { World.new(15, 15) }
  let(:config)  { level_configuration[:world][:builder] }
  let(:builder) { Builder::World.new(world) }

  it "should create a vegetation" do
    world = builder.create(config)
    world.each_field do |field|
      expect(field.vegetation).to be_instance_of(Vegetation)
    end
  end

end
