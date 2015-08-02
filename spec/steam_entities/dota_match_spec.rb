require 'spec_helper'
require 'dota_steam/steam_entities/dota_match'
require 'json'

describe 'DotaSteam::SteamEntities::DotaMatch' do
  let(:match_hash_history) do
    content = File.read('./json_responses/getMatchHistory.json')
    json = JSON.parse(content)
    json['result']['matches'][0]
  end

  let(:match_hash_full) do
    content = File.read('./json_responses/getMatchDetails.json')
    json = JSON.parse(content)
    json['result']
  end

  let(:match_attributes_history) do
    [:match_id, :match_seq_num, :start_time, :lobby_type, :radiant_team_id, :dire_team_id, :players]
  end

  let(:match_attributes_full) do
    [
     :match_id, :start_time, :lobby_type, :lobby_type, :radiant_win, :duration, :tower_status_radiant, :tower_status_dire,
     :barracks_status_radiant, :barracks_status_dire, :cluster, :first_blood_time, :human_players, :league_id, :positive_votes,
     :negative_votes, :engine
    ]
  end

  describe '#self.new_from_history && #self.add_players_history' do
    it 'creates a match' do
      match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash_history)
      DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash_history)
      expect(match).not_to be nil

      match_attributes_history.each do |at|
        expect(match.send(at)).not_to be nil
      end
      expect(match.players.size).to be > 0
    end
  end

  describe '#self.new_from_full && #self.add_players_full' do
    it 'creates a match' do
      match = DotaSteam::SteamEntities::DotaMatch.new_from_full(match_hash_full)
      DotaSteam::SteamEntities::DotaMatch.add_players_full(match, match_hash_full)
      expect(match).not_to be nil

      match_attributes_full.each do |at|
        expect(match.send(at)).not_to be nil
      end
      expect(match.players.size).to be > 0
    end
  end

  describe '#radiant' do
    it 'returns two radiant players' do
      player_1 = DotaSteam::SteamEntities::DotaPlayer.new
      player_1.player_slot = 0

      match = DotaSteam::SteamEntities::DotaMatch.new
      match.players = [player_1]

      expect(match.radiant.size).to eq 1
    end
  end

  describe '#dire' do
    it 'returns two dire players' do
      player_1 = DotaSteam::SteamEntities::DotaPlayer.new
      player_1.player_slot = 128

      match = DotaSteam::SteamEntities::DotaMatch.new
      match.players = [player_1]

      expect(match.dire.size).to eq 1
    end
  end

  describe '#self.add_players_history' do
    before do
      @match = DotaSteam::SteamEntities::DotaMatch.new
    end
    context 'hash has no players' do
      it 'players are [] and warns' do
        DotaSteam::SteamEntities::DotaMatch.add_players_history(@match, {})
        expect(@match.players).to be_empty
      end
    end
  end
end