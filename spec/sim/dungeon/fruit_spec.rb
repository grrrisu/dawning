require 'spec_helper'

describe Dungeon::Map do

  let(:fruit) { Dungeon::Fruit.build capacity: Dungeon::Fruit::Banana2 }

  it "should set food_points to capacity" do
    expect(fruit.food_points).to eq(Dungeon::Fruit::Banana2)
  end

  it "should collect food_points" do
    expect(fruit.collect).to be == Dungeon::Fruit::Banana2
    expect(fruit.collect).to be == 0
  end

end
