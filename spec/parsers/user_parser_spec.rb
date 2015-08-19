require 'spec_helper'
require 'dota_steam/parsers/user_parser'


describe 'DotaSteam::Parsers::UserParser' do
  subject(:parser){ DotaSteam::Parsers::UserParser.new(['76561197960435530']) }

  describe '#parse' do
    it 'returns an arrray of users' do
      stub_request(:get, 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&steamids=76561197960435530').
          with(headers: { connection: 'close', host: 'api.steampowered.com', user_agent: / *./}).
          to_return(:status => 200, :body => File.read('./json_responses/getPlayerSummaries.json'), :headers => {})

      parser.parse
      expect(parser.result.size).to eq 1
      expect(parser.status).to eq :done
    end
  end
end