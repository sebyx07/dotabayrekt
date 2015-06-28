module DotaSteam
  module SteamEntities
    class SteamUser
      attr_accessor :steam_id, :community_visibility_state, :profile_state, :persona_name, :last_log_off, :profile_url,
                  :avatar, :persona_state, :real_name, :primary_clan_id, :time_created, :persona_state_flags,
                  :loc_country_code, :loc_state_code, :loc_city_id

      def dota2_id
        if @steam_id
          steam_id - 76561197960265728
        end
      end

      def attributes
        Hash.new({
                     steam_id: steam_id,
                     dota2_id: dota2_id,
                     community_visibility_state: community_visibility_state,
                     persona_name: persona_name,
                     last_log_off: last_log_off,
                     profile_url: profile_url,
                     avatar: avatar,
                     persona_state: persona_state,
                     real_name: real_name,
                     primary_clan_id: primary_clan_id,
                     time_created: time_created,
                     persona_state_flags: persona_state_flags,
                     loc_country_code: loc_country_code,
                     loc_state_code: loc_state_code,
                     loc_city_id: loc_city_id
                 })
      end

      # Static

      class << self
        def new_from_hash(hash)
          user = self.new

          user.steam_id = hash['steamid'].to_i
          user.community_visibility_state = hash['communityvisibilitystate']
          user.profile_state = hash['profilestate']
          user.persona_name = hash['personaname']
          user.last_log_off = hash['lastlogoff']
          user.profile_url = hash['profileurl']
          user.avatar = hash['avatar']
          user.persona_state = hash['personastate']
          user.real_name = hash['realname']
          user.primary_clan_id = hash['primaryclanid']
          user.time_created = hash['timecreated']
          user.persona_state_flags = hash['personastateflags']
          user.loc_country_code = hash['loccountrycode']
          user.loc_state_code = hash['locstatecode']
          user.loc_city_id = hash['loccityid']

          user
        end
      end
    end
  end
end