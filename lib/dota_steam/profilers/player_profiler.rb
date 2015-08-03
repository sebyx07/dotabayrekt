require 'dota_steam/profilers/game_play'
module DotaSteam
  module Profilers
    module PlayerProfiler
      include DotaSteam::Profilers::GamePlay
      def role_by_hero(hero_id)
        cache = DotaSteam.configuration.heroes_cache
        cache.get(hero_id)[:role]
      end

      def profile_by_gameplay(hero_role, player, ally_kills, match_duration)
        case hero_role
          when 1
            [:carry, carry_gameplay(player, ally_kills, match_duration)]
          when 2
            [:support, support_gameplay(player, ally_kills)]
          when 3
            [:mid, mid_gameplay(player, ally_kills, match_duration)]
          when 4
            [:offlane, offlane_gameplay(player, ally_kills, match_duration)]
          when 5
            [:jungle, jungle_gameplay(player, ally_kills, match_duration)]
          else
            :unknown
        end
      end
    end
  end
end