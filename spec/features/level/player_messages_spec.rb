require "spec_helper"

describe "player messages" do

  let(:level)             { Level.new }
  let(:player_connection) { Sim::Net::PlayerConnection.new('socket') }
  let(:player)            { Player::Member.new '123', level }
  let(:config)            { Rails.root.join('config', 'levels', 'test.yml').to_s }
  let(:hq)                { player.headquarter }

  before(:each) do
    player_connection.instance_variable_set('@player', player)
    player.connection = player_connection
    Sim::Queue::Master.setup $stderr, level
    level.build config
    level.start
    level.dropzone.place_player player
  end

  it "should return init_map" do
    expect(player_connection).to receive(:send_message).with(
      :init_map, hash_including(world: {height: 15, width: 15},
                                headquarter: hash_including(x: hq.x, y: hq.y, pawns: instance_of(Array))
                               )
    )
    player_connection.forward_message player_id: '123',
      action: 'init_map', params: {}
  end

  it "should return move" do
    expect(player_connection).to receive(:send_message).with(
      :move, hash_including(pawn_id: hq.id, x: hq.x, y: hq.y + 1)
    )
    player_connection.forward_message player_id: '123',
      action: 'move', params: {pawn_id: hq.id, x: hq.x, y: hq.y + 1}
  end

  it "should return view" do
    expect(player_connection).to receive(:send_message).with(
      :view, hash_including(x: hq.x - 2, y: hq.y - 2, view: instance_of(Sim::Matrix))
    )
    player_connection.forward_message player_id: '123',
      action: 'view', params: {x: hq.x - 2, y: hq.y - 2, width: 5, height: 5}
  end

end
