require 'spec_helper'
require 'dota_steam/steam_entities/dota_player'
require 'json'

describe 'DotaSteam::SteamEntities::DotaPlayer' do
  let(:player_hash) do
    content = File.read('./json_responses/getMatchHistory.json')
    json = JSON.parse(content)
    json['result']['matches'][0]['players'][0]
  end

  let(:player_attributes) do
    [:account_id, :player_slot, :hero_id]
  end

  describe '#self.new_from_history' do
    it 'creates a player' do
      player = DotaSteam::SteamEntities::DotaPlayer.new_from_history(player_hash)
      expect(player).not_to be nil

      player_attributes.each do |at|
        expect(player.send(at)).not_to be nil
      end
    end
  end
end