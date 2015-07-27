require 'spec_helper'
require 'dota_steam/rate/match_rate'
require 'dota_steam/rate/role_assessment'

RSpec.describe DotaSteam::Rate::MatchRate do

  before do
    assessment = DotaSteam::Rate::RoleAssessment.new({
                                                        kills_points: {target_percent: 20, max_points: 1000},
                                                        deaths_points: {penalty_points: 300},
                                                        assists_points: {target_percent: 10, max_points: 1000},
                                                        lh_points: {target_per_time: 140, time_sec: 600, max_points: 1000},
                                                        denies_points: {target_value: 30, max_points: 1000},
                                                        net_worth_points: {target_per_time: 8000, time_sec: 600,  max_points: 1000},
                                                        xpm_points: {target_value: 1000, max_points: 1000},
                                                        gpm_points: {target_value: 1000, max_points: 1000},
                                                        level_advantage_points: {penalty_points: 200, max_points: 1000},
                                                        win_points: {max_points: 1000, disabled: true}
                                                    })

    stub_request(:get, 'http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?key=EE4B46697AAE3B64E5E4334E10E7AB0F&match_id=1662189584').
        with(headers: { connection: 'Keep-Alive', host: 'api.steampowered.com', user_agent: 'http.rb/0.9.0'}).
        to_return(:status => 200, :body => File.read('./json_responses/getMatchDetails.json'), :headers => {})

    parser = DotaSteam::Parsers::MatchDetailsParser.new
    parser.parse_matches ['1662189584']

    match = parser.result[0]

    @rat = DotaSteam::Rate::MatchRate.new(match, {
                                              match.players[0] => assessment,
                                              match.players[1] => assessment,
                                              match.players[2] => assessment,
                                              match.players[3] => assessment,
                                              match.players[4] => assessment,
                                              match.players[5] => assessment,
                                              match.players[6] => assessment,
                                              match.players[7] => assessment,
                                              match.players[8] => assessment,
                                              match.players[9] => assessment,
                                               })

    @rat.rate
    @player_rate = @rat.player_ratings[0]
  end

  describe '#rate' do
    it 'has stats' do
      expect(@player_rate.kills_score).to eq 322
      expect(@player_rate.deaths_score).to eq -1200
      expect(@player_rate.assists_score).to eq 1000
      expect(@player_rate.lh_score).to eq 152
      expect(@player_rate.denies_score).to eq 33
      expect(@player_rate.xpm_score).to eq 434
      expect(@player_rate.gpm_score).to eq 411
      expect(@player_rate.level_advantage_score).to eq 1000
      expect(@player_rate.win_score).to eq 0
      expect(@player_rate.final_score).to eq 2753
    end
  end
end