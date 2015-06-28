require 'spec_helper'
require 'dota_steam/steam_entities/user'
require 'json'

describe 'DotaSteam::SteamEntities::User' do
  let(:hash) do
    content = File.read('./json_responses/getPlayerSummaries.json')
    json = JSON.parse(content)
    json['response']['players'][0]
  end

  describe '#self.new_from_hash' do
    it 'creates a user from a hash' do
      user = DotaSteam::SteamEntities::User.new_from_hash(hash)

      expect(user).not_to be nil
    end
  end

  describe '#attributes' do
    it 'returns all attributes' do
      user = DotaSteam::SteamEntities::User.new

      expect(user.attributes).not_to be nil
    end
  end
end