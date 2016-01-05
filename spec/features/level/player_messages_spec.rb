require "spec_helper"

describe "player messages" do

  let(:level)             { Level.instance }
  let(:player_connection) { Sim::Net::PlayerConnection.new('socket') }
  let(:player)            { Player::Member.new '123', level }
  let(:config)            { Rails.root.join('config', 'levels', 'test.yml').to_s }
  let(:hq)                { player.headquarter }
  let(:logfile)           { File.open(File.expand_path("../../../../log/level.log", __FILE__), 'a') }

  before(:each) do
    player_connection.instance_variable_set('@player', player)
    player.connection = player_connection
    level.build config
  end

  describe 'map' do

    before :each do
      level.start
      level.dropzone.place_player player
    end

    it "should return init_map" do
      expect(player_connection).to receive(:send_message).with(
        :init_map, hash_including(headquarter: hash_including(x: hq.x, y: hq.y, pawns: instance_of(Array))                )
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
        action: 'view', params: { x: hq.x - 2, y: hq.y - 2, width: 5, height: 5,
                                  current_view: {x: hq.x - 4, y: hq.y - 4, width: 15, height: 15}
                                }
    end

  end

  describe 'dungeon' do

    let(:dungeon_config) { {dungeon: {data_file: 'test/dungeon_data.json'}} }
    let(:dungeon)        { level.create_dungeon dungeon_config }
    let(:x_for_banana_2) { 2 * dungeon.map.field_size + 10 }
    let(:y_for_banana_2) { 1 * dungeon.map.field_size + 10 }

    it "should build dungeon" do
      expect(player_connection).to receive(:send_message).with(
        :init_dungeon, pawn_id: 123, food_points: 0, fields: instance_of(Sim::Matrix)
      )
      fields = player_connection.forward_message player_id: '123', action: 'init_dungeon', params: {}
      expect(level.dungeon).to be_instance_of(Dungeon::Actor)
    end

    it "should add player" do
      expect(player_connection).to receive(:send_message)
      player_connection.forward_message player_id: '123', action: 'init_dungeon', params: {}
      found_player = level.dungeon.wrapped_object.find_player('123')
      expect(found_player.id).to eq(player.id)
    end

    it "should collect food" do
      player.food_points = 0
      expect(player_connection).to receive(:send_message).with(
        :update_food_points, {food_points: Dungeon::Fruit::Banana2}
      )
      player_connection.forward_message player_id: '123', action: 'food_collected', params: {
        position: {isoX: x_for_banana_2, isoY: y_for_banana_2}
      }
    end

    it "should win game" do
      player.food_points = dungeon.map.total_food_points - Dungeon::Fruit::Banana2
      expect(player_connection).to receive(:send_message).with(
        :dungeon_end, {food_points: dungeon.map.total_food_points, rank: 1}
      )
      player_connection.forward_message player_id: '123', action: 'food_collected', params: {
        position: {isoX: x_for_banana_2, isoY: y_for_banana_2}
      }
    end

    it "should loose game" do
      player.food_points = 20
      expect(player_connection).to receive(:send_message).with(
        :dungeon_end, {food_points: 20, rank: 0}
      )
      player_connection.forward_message player_id: '123', action: 'attacked', params: {
        food_points: 20, position: {isoX: x_for_banana_2, isoY: y_for_banana_2}
      }
    end

  end

end
