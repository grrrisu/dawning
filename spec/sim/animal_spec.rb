require 'spec_helper'

describe Animal do

  context "aging" do

    it "should get older" do
      animal = Animal.build
      allow(animal).to receive(:delay).and_return(4)
      animal.aging
      expect(animal.age).to be == 4
      expect(animal.next_birth).to be == 4
    end

    it "should reproduce" do
      animal = Animal.build age: 2, next_birth: 2
      allow(animal).to receive_message_chain(:world, select: [Field.new])
      expect(animal).to receive_message_chain(:sim_loop, :add)
      allow(animal).to receive(:delay).and_return(4)
      animal.aging
      expect(animal.next_birth).to be == 2 + 4 - 5
      # TODO
      # expect(event_queue).to receive(:fire).with(reproduce_event)
    end

    it "should die" do
      animal = Animal.build age: 28, age_death: 30
      allow(animal).to receive(:delay).and_return(4)
      expect(animal).to receive(:die!)
      animal.aging
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

    context "move_to" do

      it "should move to target field" do
        animal.move_to world[1,2]
        expect(animal.field).to eq(world[1,2])
        expect(world[1,2][:fauna]).to eq(animal)
        expect(world[1,1][:fauna]).to be_nil
      end

      it "should return a notification area" do
        area = animal.move_to world[1,2]
        expect(area).to eq Hashie::Mash.new(x: 1, y: 1, width: 1, height: 2)
      end

    end

    context "die!" do

      let(:sim_loop) { double(Sim::Queue::SimLoop) }

      before :each do
        allow(animal).to receive(:sim_loop).and_return(sim_loop)
        expect(sim_loop).to receive(:remove).with(animal)
      end

      it "should raise Death" do
        expect { animal.die! }.to raise_error(Death)
      end

      it "should detach itself" do
        animal.die
        expect(animal.field).to be_nil
        expect(world[1,1].fauna).to be_nil
      end

    end

  end

end
