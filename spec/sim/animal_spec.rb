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
      pending
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

  describe "think" do

  end

  describe "look_around" do

  end

  describe "move_to" do

  end

  describe "sim" do

  end

end
