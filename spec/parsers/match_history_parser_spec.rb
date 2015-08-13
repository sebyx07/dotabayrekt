require 'spec_helper'
require 'dota_steam/parsers/match_history_parser'


describe 'DotaSteam::Parsers::MatchHistoryParser' do

  describe '#parse_full_history' do
    let(:parser){ DotaSteam::Parsers::MatchHistoryParser.new }

    before do
      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F').
          with(headers: { connection: 'Keep-Alive', host: 'api.steampowered.com', user_agent: 'http.rb/0.9.0'}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistory.json'), :headers => {})

      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&start_at_match_id=1589628135').
          with(headers: { connection: 'Keep-Alive', host: 'api.steampowered.com', user_agent: 'http.rb/0.9.0'}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistoryLast.json'), :headers => {})
    end

    it 'returns an array of users' do


      parser.parse_full_history
      expect(parser.result.size).to eq 3
      expect(parser.status).to eq :done
    end
  end

  describe '#parse_until_match' do
    let(:parser){ DotaSteam::Parsers::MatchHistoryParser.new(account_id: 1234) }

    before do
      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?account_id=1234&key=EE4B46697AAE3B64E5E4334E10E7AB0F').
          with(headers: { connection: 'Keep-Alive', host: 'api.steampowered.com', user_agent: 'http.rb/0.9.0'}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistory.json'), :headers => {})

      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?account_id=1234&key=EE4B46697AAE3B64E5E4334E10E7AB0F&start_at_match_id=1589628135').
          with(headers: { connection: 'Keep-Alive', host: 'api.steampowered.com', user_agent: 'http.rb/0.9.0'}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistoryLast.json'), :headers => {})
    end

    it 'returns 0 matches' do
      parser.parse_until_match '1589628135'
      expect(parser.result.size).to eq 0
      expect(parser.status).to eq :done
    end

    it 'returns 2 matches' do
      parser.parse_until_match '1589628137'
      expect(parser.result.size).to eq 2
      expect(parser.status).to eq :done
    end
  end
end