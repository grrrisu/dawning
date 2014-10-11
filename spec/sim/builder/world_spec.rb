require 'spec_helper'

describe Builder::World do

  let(:world)   { World.new(15, 15) }
  let(:config)  { level_configuration[:world][:builder] }
  let(:builder) { Builder::World.new(world) }

  before(:each) do
    world = builder.create(config)
  end

  it "should create a vegetation" do
    world.each_field do |field|
      expect(field.vegetation).to be_instance_of(Vegetation)
    end
  end

  it "should create flora" do
    field_with_flora = world.find {|field| field.flora? }
    expect(field_with_flora).to_not be_nil
  end

  it "should create fauna" do
    field_with_fauna = world.find {|field| field.fauna? }
    expect(field_with_fauna).to_not be_nil
  end

end
