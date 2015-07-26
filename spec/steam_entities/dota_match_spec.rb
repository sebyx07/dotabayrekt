require 'spec_helper'
require 'dota_steam/steam_entities/dota_match'
require 'json'

describe 'DotaSteam::SteamEntities::DotaMatch' do
  let(:match_hash) do
    content = File.read('./json_responses/getMatchHistory.json')
    json = JSON.parse(content)
    json['result']['matches'][0]
  end

  let(:match_attributes) do
    [:match_id, :match_seq_num, :start_time, :lobby_type, :radiant_team_id, :dire_team_id]
  end

  describe '#self.new_from_history && #self.add_players' do
    it 'creates a match' do
      match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
      DotaSteam::SteamEntities::DotaMatch.add_players(match, match_hash)
      expect(match).not_to be nil

      match_attributes.each do |at|
        expect(match.send(at)).not_to be nil
      end
      expect(match.players.size).to be > 0
    end
  end
end