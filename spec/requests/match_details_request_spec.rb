require 'spec_helper'
require 'dota_steam/requests/match_details_request'


describe 'DotaSteam::Requests::MatchDetailsRequest' do
  subject(:req){ DotaSteam::Requests::MatchDetailsRequest.new(match_id: 1662189584) }

  describe '#run' do
    it 'makes http request to steam' do
      stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&match_id=1662189584').
          with(headers: { connection: 'close', host: 'api.steampowered.com', user_agent: 'http.rb/0.9.0'}).
          to_return(:status => 200, :body => File.read('./json_responses/getMatchHistory.json'), :headers => {})

      req.run

      expect(req.status).to equal 200
    end
  end
end