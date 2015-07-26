require 'spec_helper'
require 'dota_steam/steam_entities/dota_player'
require 'json'

describe 'DotaSteam::SteamEntities::DotaPlayer' do
  let(:player_hash_history) do
    content = File.read('./json_responses/getMatchHistory.json')
    json = JSON.parse(content)
    json['result']['matches'][0]['players'][0]
  end

  let(:player_hash_full) do
    content = File.read('./json_responses/getMatchDetails.json')
    json = JSON.parse(content)
    json['result']['players'][6]
  end

  let(:player_attributes_history) do
    [:account_id, :player_slot, :hero_id]
  end

  let(:player_attributes_full) do
    player_attributes_history.push(
      :items, :bear_items, :kills, :deaths, :assists, :leaver_status, :gold, :last_hits, :denies, :gpm, :xpm, :gold_spent,
      :hero_damage, :tower_damage, :hero_healing, :level, :lvlups, :net_worth
    )
  end

  describe '#self.new_from_history' do
    it 'creates a player' do
      player = DotaSteam::SteamEntities::DotaPlayer.new_from_history(player_hash_history)
      expect(player).not_to be nil

      player_attributes_history.each do |at|
        expect(player.send(at)).not_to be nil
      end
    end
  end

  describe '#self.new_from_full' do
    it 'creates a player' do
      player = DotaSteam::SteamEntities::DotaPlayer.new_from_full(player_hash_full)
      expect(player).not_to be nil

      player_attributes_full.each do |at|
        expect(player.send(at)).not_to be nil
      end
    end
  end

  describe '#radiant?' do
    it 'returns true if players is radiant' do
      player = DotaSteam::SteamEntities::DotaPlayer.new
      player.player_slot = 0
      expect(player.radiant?).to be true
    end

    it 'returns false if players is dire' do
      player = DotaSteam::SteamEntities::DotaPlayer.new
      player.player_slot = 128
      expect(player.radiant?).to be false
    end
  end
end