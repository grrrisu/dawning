require 'spec_helper'

describe LevelProxy do

  let (:connection) { double(Sim::Net::ParentConnection) }
  let (:level) { LevelProxy.new('123', 'test') }

  describe 'without connection' do

    before :each do
      allow(Sim::Net::ParentConnection).to receive(:new).and_return(connection)
      expect(connection).to receive(:launch_subprocess)
    end

    it "should create and launch" do
      expect {
        LevelProxy.create('test')
      }.to change{LevelProxy.levels.size}.by(1)
    end

    it "should launch level" do
      level.launch
      expect(level.name).to eq('test')
      expect(level.id).to eq('123')
      expect(level.state).to eq(:launched)
    end

  end

  describe 'with connection' do

    before :each do
      level.instance_variable_set('@connection', connection)
      LevelProxy.instance_variable_set('@levels', {level.id => level})
    end

    it "should find level" do
      expect(LevelProxy.find(level.id)).to eq(level)
    end

    it "should build a level" do
      level.instance_variable_set('@state', :launched)
      expect(connection).to receive(:send_action).with(:build, config_file: an_instance_of(String))
      level.build('default.yml')
      expect(level.state).to eq(:ready)
    end

    it "should not build level" do
      [:ready, :running, :stopped].each do |state|
        level.instance_variable_set('@state', state)
        expect(connection).to receive(:send_action).never
        expect { level.build }.to raise_error(ArgumentError)
      end
    end

    it "should start a level" do
      level.instance_variable_set('@state', :ready)
      expect(connection).to receive(:send_action).with(:start)
      level.start
      expect(level.state).to eq(:running)
    end

    it "should not start level" do
      [:launched, :running, :stopped].each do |state|
        level.instance_variable_set('@state', state)
        expect(connection).to receive(:send_action).never
        expect { level.start }.to raise_error(ArgumentError)
      end
    end

    it "should stop a level" do
      level.instance_variable_set('@state', :running)
      expect(connection).to receive(:send_action).with(:stop)
      level.stop
      expect(level.state).to eq(:stopped)
    end

    it "should not stop level" do
      [:launched, :ready, :stopped].each do |state|
        level.instance_variable_set('@state', state)
        expect(connection).to receive(:send_action).never
        expect { level.stop }.to raise_error(ArgumentError)
      end
    end

    it "should remove a level" do
      level.instance_variable_set('@state', :stopped)
      expect {
        level.remove
      }.to change{LevelProxy.levels.size}.by(-1)
      expect(level.state).to eq(:destroyed)
    end

    it "should not remove level" do
      [:launched, :ready, :running].each do |state|
        level.instance_variable_set('@state', state)
        expect { level.remove }.to raise_error(ArgumentError)
      end
    end

  end

end
