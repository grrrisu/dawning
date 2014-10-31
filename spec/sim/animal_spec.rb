require 'spec_helper'

describe Animal do

  context "aging" do

    it "should get older" do
      animal = Animal.build
      animal.aging 4
      expect(animal.age).to be == 4
      expect(animal.next_birth).to be == 4
    end

    it "should reproduce" do
      animal = Animal.build age: 2, next_birth: 2
      animal.aging 4
      expect(animal.next_birth).to be == 2 + 4 - 5
      # TODO
      # expect(event_queue).to receive(:fire).with(reproduce_event)
    end

    it "should die" do
      animal = Animal.build age: 28, age_death: 30
      expect { animal.aging 4 }.to raise_error(Death)
    end

  end

  context "food_eaten" do

    let(:field) { Field.new vegetation: Vegetation.build(size: 650) }

    it "should calculate food for rabbit" do
      animal = Animal.build max_health: 40, needed_food: 5
      animal.field = field
      eaten = animal.food_eaten
      expect(eaten).to be_within(0.1).of(6.66)
      expect(field.vegetation.size).to be == 650 - 20
    end

    it "should calculate food for gazelle" do
      animal = Animal.build max_health: 100, needed_food: 15
      animal.field = field
      eaten = animal.food_eaten
      expect(eaten).to be_within(0.1).of(16.66)
      expect(field.vegetation.size).to be == 650 - 50
    end

    it "should calculate food for mammouth" do
      animal = Animal.build max_health: 160, needed_food: 130
      animal.field = field
      eaten = animal.food_eaten
      expect(eaten).to be_within(0.1).of(26.66)
      expect(field.vegetation.size).to be == 650 - 80
    end

  end

  context "eat" do

    let(:animal) { Animal.build }

    before(:each) do
      allow(animal).to receive_message_chain(:field, :vegetation, :calculate)
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
      expect { animal.eat 4 }.to raise_error(Death)
    end

  end

  context "in a world" do

    let(:animal)  { Animal.build }
    let(:world)   { World.new(3,3) }

    before :each do
      allow(animal).to receive(:world).and_return(world)
      world[1,1].merge!(fauna: animal)
      animal.field = world[1,1]
    end

    context "looks around" do

      it "should return an array of fields" do
        fields = animal.look_around
        expect(fields.size).to be == 3 * 3
        fields.each do |field|
          expect(field).to be_instance_of(Field)
        end
      end

    end

    context "most_profitable_field" do

      it "should choose best free field" do
        field_low       = Field.new vegetation: Vegetation.build(size: 10)
        field_medium    = Field.new vegetation: Vegetation.build(size: 20)
        field_high      = Field.new vegetation: Vegetation.build(size: 30), fauna: nil
        field_occupied  = Field.new vegetation: Vegetation.build(size: 50), fauna: 'leopard'
        result = animal.most_profitable_field [field_low, field_high, field_occupied, field_medium]
        expect(result).to eq(field_high)
      end

    end

    context "move_to" do

      it "should move to target field" do
        animal.move_to world[1,2]
        expect(animal.field).to eq(world[1,2])
        expect(world[1,2][:fauna]).to eq(animal)
        expect(world[1,1][:fauna]).to be_nil
      end

      it "should return a notification area" do
        area = animal.move_to world[1,2]
        expect(area).to be == {x: 1, y: 1, width: 1, height: 2}
      end

    end

    context "think" do

    end

    context "sim" do

    end

  end

end
