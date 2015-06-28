require 'spec_helper'
require 'dota_steam/requests/steam_user_request'


describe 'DotaSteam::Requests::SteamUserRequest' do
  subject(:req){ DotaSteam::Requests::SteamUserRequest.new('76561197960435530') }

  describe '#run' do
    it 'makes http request to steam' do
      stub_request(:get, 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&steamids=76561197960435530').
          with(headers: { connection: 'close', host: 'api.steampowered.com', user_agent: 'http.rb/0.8.12'}).
          to_return(:status => 200, :body => File.read('./json_responses/getPlayerSummaries.json'), :headers => {})

      req.run

      expect(req.status.to_i).to equal 200
    end
  end
end