require 'spec_helper'

describe Builder::World do

  let(:world)   { World.new(15, 15) }
  let(:config)  { level_configuration[:world][:builder] }
  let(:builder) { Builder::World.new(world) }

  before(:each) do
    Celluloid::Actor[:time_unit] = Sim::TimeUnit.new 1
    Celluloid::Actor[:sim_loop]  = Sim::Queue::SimLoop.new(10, [])
    world = builder.create(config)
  end

  it "should create a vegetation" do
    world.each_field do |field|
      expect(field.vegetation).to be_instance_of(Vegetation)
    end
  end

  it "should add vegetation to sim loop" do
    expect(Celluloid::Actor[:sim_loop].objects.size).to eq(15 * 15)
  end

  it "should create flora" do
    field_with_flora = world.find {|field| field.flora? }
    expect(field_with_flora).to_not be_instance_of(Flora)
  end

  it "should create fauna" do
    field_with_fauna = world.find {|field| field.fauna? }
    expect(field_with_fauna).to_not be_nil
  end

end
