require 'spec_helper'
require 'dota_steam/parsers/match_history_parser'


describe 'DotaSteam::Parsers::MatchHistoryParser' do

  describe '#parse' do
    let(:parser){ DotaSteam::Parsers::MatchDetailsParser.new }

    it 'returns an arrray of users' do
      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&match_id=1662189584').
          with(headers: { connection: 'Keep-Alive', host: 'api.steampowered.com', user_agent: / *./}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchDetails.json'), :headers => {})

      parser.parse_matches(['1662189584', '1662189584'])
      expect(parser.result.size).to eq 2
      expect(parser.status).to eq :done
    end
  end
end