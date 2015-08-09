require 'spec_helper'

describe Pawn do

  let(:pawn) { Pawn.build(x: 5, y: 5) }

  it "view value" do
    value = pawn.view_value
    expect(value[:type]).to be == 'base'
    expect(value[:id]).to be_instance_of(Fixnum)
  end

end
