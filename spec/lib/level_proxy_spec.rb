require 'spec_helper'

describe LevelProxy do

  let (:connection) { mock(Sim::Popen::ParentConnection) }
  let (:level) { LevelProxy.new('123', 'test') }

  describe 'without connection' do

    before :each do
      Sim::Popen::ParentConnection.stub(:new).and_return(connection)
      connection.should_receive(:launch_subprocess)
    end

    it "should create and launch" do
      expect {
        LevelProxy.create('test')
      }.to change{LevelProxy.levels.size}.by(1)
    end

    it "should launch level" do
      level.launch
      level.name.should == 'test'
      level.id.should == '123'
      level.state.should == :launched
    end

  end

  describe 'with connection' do

    before :each do
      level.instance_variable_set('@connection', connection)
      LevelProxy.instance_variable_set('@levels', {level.id => level})
    end

    it "should find level" do
      LevelProxy.find(level.id).should == level
    end

    it "should build a level" do
      level.instance_variable_set('@state', :launched)
      connection.should_receive(:send_action).with(:build, config_file: an_instance_of(String))
      level.build('default.yml')
      level.state.should == :ready
    end

    it "should not build level" do
      [:ready, :running, :stopped].each do |state|
        level.instance_variable_set('@state', state)
        connection.should_receive(:send_action).never
        expect { level.build }.to raise_error(ArgumentError)
      end
    end

    it "should start a level" do
      level.instance_variable_set('@state', :ready)
      connection.should_receive(:send_action).with(:start)
      level.start
      level.state.should == :running
    end

    it "should not start level" do
      [:launched, :running, :stopped].each do |state|
        level.instance_variable_set('@state', state)
        connection.should_receive(:send_action).never
        expect { level.start }.to raise_error(ArgumentError)
      end
    end

    it "should stop a level" do
      level.instance_variable_set('@state', :running)
      connection.should_receive(:send_action).with(:stop)
      level.stop
      level.state.should == :stopped
    end

    it "should not stop level" do
      [:launched, :ready, :stopped].each do |state|
        level.instance_variable_set('@state', state)
        connection.should_receive(:send_action).never
        expect { level.stop }.to raise_error(ArgumentError)
      end
    end

    it "should remove a level" do
      level.instance_variable_set('@state', :stopped)
      expect {
        level.remove
      }.to change{LevelProxy.levels.size}.by(-1)
      level.state.should == :destroyed
    end

    it "should not remove level" do
      [:launched, :ready, :running].each do |state|
        level.instance_variable_set('@state', state)
        expect { level.remove }.to raise_error(ArgumentError)
      end
    end

  end

end
