require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe View do

  before(:each) do
    world = World.new(8, 8)
    @w = {w: @w}
    world.set_each_field { @w.clone }
    @view = View.new(world, 0, 0, 5)
  end

  it 'should detect wihtin radius' do
    expect(View.within_radius(1,1,2)).to be_true
    expect(View.within_radius(2,2,2)).to be_false
    expect(View.within_radius(1,2,2)).to be_true
    expect(View.within_radius(1,2,2,0)).to be_false
  end

  describe 'with pawn' do

    before(:each) do
      pawn = Pawn.new(1,1)
      @view.unfog(pawn)
    end

    it "should set pawns visibility" do
      expected = [[1, 1, 1, 0, 0], [1, 1, 1, 0, 0], [1, 1, 1, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]]
      expect(@view.fields).to be == expected
    end

    it "should filter pawns visibility to world" do
      expected = [[@w, @w, @w, nil, nil], [@w, @w, @w, nil, nil], [@w, @w, @w, nil, nil], [nil, nil, nil, nil, nil], [nil, nil, nil, nil, nil]]
      expect(@view.filter.fields).to be == expected
    end

  end

end
