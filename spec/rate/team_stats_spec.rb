require 'spec_helper'
require 'dota_steam/rate/team_stats'
require 'dota_steam/parsers/match_details_parser'

RSpec.describe DotaSteam::Rate::TeamStats do
=begin
  let(:json){JSON_MATCH}
  let(:players) do
    json['result']['players'][0..4].map{|p| Dota2ArenaCourier::Player.new(p).set_attributes}
  end
  let(:match){Dota2ArenaCourier::Match.new(json['result']).set_attributes}

  subject(:@team){Dota2ArenaCourier::Team.new(players, match.radiant_win).set_attributes}
=end

  before do
    stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&match_id=1662189584').
        with(headers: { connection: 'Keep-Alive', host: 'api.steampowered.com', user_agent: 'http.rb/0.9.0'}).
        to_return(:status => 200, :body => File.read('./json_responses/getMatchDetails.json'), :headers => {})

    parser = DotaSteam::Parsers::MatchDetailsParser.new
    parser.parse_matches ['1662189584']

    match = parser.result[0]

    @team = DotaSteam::Rate::TeamStats.new(match.radiant, match.radiant_win)
  end

  describe '@team' do
    it 'has attributes' do
      expect(@team.kills).to eq 35
      expect(@team.deaths).to eq 27
      expect(@team.assists).to eq 54
      expect(@team.xpm).to eq 2341
      expect(@team.gpm).to eq 2281
      expect(@team.net_worth).to eq 77565
      expect(@team.last_hits).to eq 499
      expect(@team.denies).to eq 10
      expect(@team.lvlups).to eq [{:players=>5, :sum=>1898}, {:players=>5, :sum=>3424}, {:players=>5, :sum=>5585}, {:players=>5, :sum=>7540}, {:players=>5, :sum=>9513}, {:players=>1, :sum=>2132}]
      expect(@team.level).to eq 85
      expect(@team.win).to be true
    end
  end
end