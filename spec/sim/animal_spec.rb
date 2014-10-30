require 'spec_helper'

describe Animal do

  describe "aging" do

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
      animal = Animal.build age: 28
      expect { animal.aging 4 }.to raise_error(Death)
    end

  end

  describe "eat" do

    it "should increase health" do
      pending "wait for smart formula"
      animal = Animal.build
      allow(animal).to receive_message_chain(:field, :vegetation, size: 600)
      expect(animal).to receive_message_chain(:field, :vegetation, :sim)
      animal.eat 4
      expect(animal.health).to be == 0
    end

    it "should not excide max health" do
      animal = Animal.build
      allow(animal).to receive(:food_eaten).and_return(500)
      animal.eat 4
      expect(animal.health).to be == 100
    end

    it "should decrease health" do
      animal = Animal.build
      allow(animal).to receive(:food_eaten).and_return(15)
      animal.eat 2
      expect(animal.health).to be == 50 - 2 * 5
    end

    it "should die" do
      animal = Animal.build health: 10
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

    describe "looks around" do

      it "should return an array of fields" do
        fields = animal.look_around
        expect(fields.size).to be == 3 * 3
        fields.each do |field|
          expect(field).to be_instance_of(Field)
        end
      end

    end

    describe "most_profitable_field" do

      it "should choose best free field" do
        field_low       = Field.new vegetation: Vegetation.build(size: 10)
        field_medium    = Field.new vegetation: Vegetation.build(size: 20)
        field_high      = Field.new vegetation: Vegetation.build(size: 30), fauna: nil
        field_occupied  = Field.new vegetation: Vegetation.build(size: 50), fauna: 'leopard'
        result = animal.most_profitable_field [field_low, field_high, field_occupied, field_medium]
        expect(result).to eq(field_high)
      end

    end

    describe "move_to" do

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

    describe "think" do

    end

    describe "sim" do

    end

  end

end
