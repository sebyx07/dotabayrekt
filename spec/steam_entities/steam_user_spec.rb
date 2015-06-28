require 'spec_helper'
require 'dota_steam/steam_entities/steam_user'
require 'json'

describe 'DotaSteam::SteamEntities::SteamUser' do
  let(:user_hash) do
    content = File.read('./json_responses/getPlayerSummaries.json')
    json = JSON.parse(content)
    json['response']['players'][0]
  end

  let(:user_attributes) do
    [
        :steam_id, :community_visibility_state, :profile_state, :persona_name, :last_log_off, :profile_url,
        :avatar, :persona_state, :real_name, :primary_clan_id, :time_created, :persona_state_flags,
        :loc_country_code, :loc_state_code, :loc_city_id
    ]
  end

  describe '#self.new_from_hash' do
    it 'creates a user from a hash' do
      user = DotaSteam::SteamEntities::SteamUser.new_from_hash(user_hash)
      expect(user).not_to be nil

      user_attributes.each do |att|
        expect(user.send(att)).not_to be nil
      end
    end
  end

  describe '#attributes' do
    it 'returns all attributes' do
      user = DotaSteam::SteamEntities::SteamUser.new

      expect(user.attributes).not_to be nil
    end
  end
end