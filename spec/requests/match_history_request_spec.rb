require 'spec_helper'
require 'dota_steam/requests/match_history_request'


describe 'DotaSteam::Requests::MatchHistoryRequest' do
  subject(:req){ DotaSteam::Requests::MatchHistoryRequest.new }

  describe '#run' do
    it 'makes http request to steam' do
      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F').
          with(headers: { connection: 'close', host: 'api.steampowered.com', user_agent: / *./}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistory.json'), :headers => {})

      req.run

      expect(req.status).to equal 200
    end
  end
end