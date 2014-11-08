require 'spec_helper'

describe Predator do

  context "most_profitable_field" do

    let(:animal) { Predator.build }

    it "should choose field with biggest prey" do
      field_low       = Field.new vegetation: Vegetation.build(size: 10), fauna: Herbivore.build(max_health: 10)
      field_empty     = Field.new vegetation: Vegetation.build(size: 20)
      field_high      = Field.new vegetation: Vegetation.build(size: 30), fauna: Herbivore.build(max_health: 20)
      field_occupied  = Field.new vegetation: Vegetation.build(size: 50), fauna: Predator.build(max_health: 50)
      result = animal.most_profitable_field [field_low, field_high, field_occupied, field_empty]
      expect(result).to eq(field_high)
    end

    it "should choose field with biggest vegetation" do
      field_low       = Field.new vegetation: Vegetation.build(size: 10)
      field_medium    = Field.new vegetation: Vegetation.build(size: 20)
      field_high      = Field.new vegetation: Vegetation.build(size: 30), fauna: nil
      field_occupied  = Field.new vegetation: Vegetation.build(size: 50), fauna: 'leopard'
      result = animal.most_profitable_field [field_low, field_high, field_occupied, field_medium]
      expect(result).to eq(field_high)
    end

  end

  context "sim" do

    let(:animal) { Predator.build }
    let(:field)  { Field.new x: 1, y: 1, vegetation: Vegetation.build(size: 30)}
    let(:field1) { Field.new x: 0, y: 0, vegetation: Vegetation.build(size: 10), fauna: Herbivore.build(max_health: 20) }
    let(:field2) { Field.new x: 1, y: 0, vegetation: Vegetation.build(size: 20) }
    let(:field3) { Field.new x: 0, y: 1, vegetation: Vegetation.build(size: 50), fauna: Predator.build(max_health: 50) }

    before :each do
      allow(animal).to receive(:delay).and_return(2.1)
      allow(animal).to receive(:look_around).and_return([field1, field2, field3])
      animal.field = field
      @area = animal.sim
    end

    it "should age" do
      expect(animal.age).to be == 2.1
    end

    it "should inc health" do
      expect(animal.health).to be == 39.5
    end

    it "should move to prey field" do
      expect(@area).to eq(Hashie::Mash.new(height: 2, width: 2, x: 0, y: 0))
    end

  end


end
