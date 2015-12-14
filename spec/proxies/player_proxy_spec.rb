require 'spec_helper'

describe PlayerProxy do

  let(:user)    { User.new(id: '123')}
  let(:admin)   { User.new(id: '456')}

  it "should set player as role if nothing is defined", skip: true do
    proxy = PlayerProxy.new user, {}
    allow(proxy).to receive(:connect_to_players_server)
    expect(proxy.instance_variable_get('@role')).to be == :player
  end

end
