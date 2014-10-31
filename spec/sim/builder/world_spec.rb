require 'spec_helper'

describe Builder::World do

  let(:world)   { World.new(15, 15) }
  let(:config)  { level_configuration[:world] }
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
    vegetations = Celluloid::Actor[:sim_loop].objects.select {|obj| obj.instance_of?(Vegetation) }
    expect(vegetations.size).to eq(15 * 15)
  end

  it "should create flora" do
    field_with_flora = world.find {|field| field.flora? }
    expect(field_with_flora.flora).to be_kind_of(Vegetation)
  end

  it "should add flora to sim loop" do
    vegetations = Celluloid::Actor[:sim_loop].objects.select {|obj| obj.instance_of?(Flora::Banana1) }
    expect(vegetations.size).to be > 0
  end

  it "should create fauna" do
    field_with_fauna = world.find {|field| field.fauna? }
    expect(field_with_fauna.fauna).to be_kind_of(Animal)
  end

  it "should add fauna to sim loop" do
    rabbits = Celluloid::Actor[:sim_loop].objects.select {|obj| obj.instance_of?(Animal::Rabbit) }
    expect(rabbits.size).to be > 0
  end

end
