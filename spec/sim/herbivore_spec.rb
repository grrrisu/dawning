require 'spec_helper'

describe Herbivore do

  context "food_eaten" do

    let(:field) { Field.new vegetation: Vegetation.build(size: 650) }

    it "should calculate food for rabbit" do
      animal = Herbivore.build max_health: 40, needed_food: 5
      animal.field = field
      eaten = animal.food_eaten
      expect(eaten).to be_within(0.1).of(6.66)
    end

    it "should calculate food for gazelle" do
      animal = Herbivore.build max_health: 100, needed_food: 15
      animal.field = field
      eaten = animal.food_eaten
      expect(eaten).to be_within(0.1).of(16.66)
    end

    it "should calculate food for mammouth" do
      animal = Herbivore.build max_health: 160, needed_food: 130
      animal.field = field
      eaten = animal.food_eaten
      expect(eaten).to be_within(0.1).of(26.66)
    end

  end

  context "eat" do

    let(:animal) { Herbivore.build }
    let(:field) { Field.new vegetation: Vegetation.build(size: 650) }

    before :each do
      animal.field = field
    end

    it "should increase health" do
      allow(animal).to receive(:food_eaten).and_return(20)
      animal.eat 2
      expect(animal.health).to be == 50 + 2 * 5
    end

    it "should not excide max health" do
      allow(animal).to receive(:food_eaten).and_return(500)
      animal.eat 4
      expect(animal.health).to be == 100
    end

    it "should decrease health" do
      allow(animal).to receive(:food_eaten).and_return(10)
      animal.eat 2
      expect(animal.health).to be == 50 - 2 * 5
    end

    it "should die" do
      animal.health = 10
      allow(animal).to receive(:food_eaten).and_return(10)
      expect(animal).to receive(:die!)
      animal.eat 4
    end

    it "should decrease vegetation" do
      allow(animal).to receive(:food_eaten).and_return(10)
      animal.eat 1
      expect(field.vegetation.size).to be == 650 - 50
    end

  end

  context "most_profitable_field" do

    let(:animal) { Herbivore.build }

    it "should choose best free field" do
      field_low       = Field.new vegetation: Vegetation.build(size: 10)
      field_medium    = Field.new vegetation: Vegetation.build(size: 20)
      field_high      = Field.new vegetation: Vegetation.build(size: 30), fauna: nil
      field_occupied  = Field.new vegetation: Vegetation.build(size: 50), fauna: 'leopard'
      result = animal.most_profitable_field [field_low, field_high, field_occupied, field_medium]
      expect(result).to eq(field_high)
    end

  end

end
