require 'spec_helper'

describe Builder::Dropzone do

  let(:world)   { World.new(15, 15) }
  let(:config)  { level_configuration[:dropzones] }
  let(:player)  { Player.new(:id, :level) }
  let(:builder) { Builder::Dropzone.new(world, config) }

  before :each do
    allow(builder).to receive(:rand).and_return(5, 10)
  end

  it "should place players headquarter and pawns" do
    builder.place_player(player)
    hq = player.headquarter
    expect(world[5, 10][:pawn]).to eq(hq)
    expect(hq.pawns).to include(world[4, 10][:pawn], world[6, 10][:pawn])
  end

end
