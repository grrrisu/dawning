require "spec_helper"

describe "level messages" do

  let(:level)         { Level.new }
  let(:player_server) { double Sim::Net::PlayerServer }
  let(:dispatcher)    { Sim::Net::MessageDispatcher.new(level) }
  let(:config)        { Rails.root.join('config', 'levels', 'test.yml').to_s }

  before(:each) do
    level.instance_variable_set('@player_server', player_server)
    level.instance_variable_set('@dispatcher', dispatcher)
    Sim::Queue::Master.setup $stderr, level
  end

  after(:each) do
    #Sim::Queue::Master.stop if Sim::Queue::Master.alive?
  end

  it "should raise error on unknown message" do
    expect{ dispatcher.dispatch(foo: 'bar') }.to raise_error(ArgumentError)
  end

  it "should raise error on unknown action" do
    expect{ dispatcher.dispatch(action: 'foobar') }.to raise_error(ArgumentError)
  end

  it "should build level" do
    expect(dispatcher.dispatch action: 'build', params: { config_file: config}).to eq(true)
    expect(level.world).to be_instance_of(World)
  end

  it "should start level" do
    level.build config
    expect(dispatcher.dispatch action: 'start').to eq(true)
  end

  it "should stop level" do
    level.build config
    level.start
    expect(dispatcher.dispatch action: 'stop').to eq(true)
  end

  it "should add player" do
    level.build config
    level.add_player player_id: '123'
    expect(level.players['123']).to be_instance_of(Player::Member)
  end

  it "should add admin" do
    level.add_player player_id: '123', role: 'admin'
    expect(level.players['123']).to be_instance_of(Player::Admin)
  end

  it "should remove a player" do
    player = Player::Member.new('123', level)
    player.connection = double(Sim::Net::PlayerConnection)
    expect(player.connection).to receive(:close)
    level.players['123'] = player

    dispatcher.dispatch action: 'remove_player', params: {id: '123'}
    expect(level.players['123']).to be_nil
  end

end
