require 'spec_helper'

describe Player::Base do

  let(:player)        { Player::Member.new('id', 'level') }
  let(:current_view)  { {x: 2, y: 5, width: 4, height: 5} }

  before(:each) { player.current_view = current_view }

  it "should overlap if self" do
    expect(player.overlap_current_view? player.current_view_dimension).to eq(true)
  end

  it "should overlap if left top is included" do
    other = Hashie::Mash.new x: 3, y: 8, width: 4, height: 5
    expect(player.overlap_current_view? other).to eq(true)
  end

  it "should overlap if right top is included" do
    other = Hashie::Mash.new x: 1, y: 8, width: 4, height: 5
    expect(player.overlap_current_view? other).to eq(true)
  end

  it "should overlap if left bottom is included" do
    other = Hashie::Mash.new x: 1, y: 2, width: 4, height: 5
    expect(player.overlap_current_view? other).to eq(true)
  end

  it "should overlap if right bottom is included" do
    other = Hashie::Mash.new x: 3, y: 2, width: 4, height: 5
    expect(player.overlap_current_view? other).to eq(true)
  end

  it "should not overlap if left top is outside" do
    other = Hashie::Mash.new x: 7, y: 8, width: 4, height: 5
    expect(player.overlap_current_view? other).to eq(false)
  end

end
