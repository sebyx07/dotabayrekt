require 'spec_helper'
require 'dota_steam/steam_entities/dota_match'
require 'dota_steam/steam_entities/dota_player'
require 'json'

describe 'DotaSteam::SteamEntities::DotaMatch' do
  let(:match_hash) do
    content = File.read('./json_responses/getMatchHistory.json')
    json = JSON.parse(content)
    json['result']['matches'][0]
  end

  describe '#self.new_from_history' do
    it 'creates a match' do
      match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
      expect(match).not_to be nil
    end
  end
end