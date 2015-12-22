require 'spec_helper'

describe Dungeon::Map do

  it "should set food_points to capacity" do
    fruit = Dungeon::Fruit.build capacity: Dungeon::Fruit::Banana2
    expect(fruit.food_points).to eq(Dungeon::Fruit::Banana2)
  end

end
