require 'spec_helper'
require 'dota_steam/parsers/match_history_parser'


describe 'DotaSteam::Parsers::MatchHistoryParser' do

  describe '#parse' do
    let(:parser){ DotaSteam::Parsers::MatchHistoryParser.new }

    it 'returns an arrray of users' do
      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F').
          with(headers: { connection: 'close', host: 'api.steampowered.com', user_agent: 'http.rb/0.8.12'}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistory.json'), :headers => {})

      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&start_at_match_id=1589628135').
          with(headers: { connection: 'close', host: 'api.steampowered.com', user_agent: 'http.rb/0.8.12'}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistoryLast.json'), :headers => {})

      parser.parse_full_history
      expect(parser.result.size).to eq 2
      expect(parser.status).to eq :done
    end
  end
end