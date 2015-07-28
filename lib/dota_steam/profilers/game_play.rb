require 'dota_steam/rate/rating_functions'
module DotaSteam
  module Profilers
    module GamePlay
      include DotaSteam::Rate::RatingFunctions
      def carry_gameplay(player, ally_kills, match_duration)
        hash = DotaSteam.configuration.gameplay_profilers_cache.json[:carry]
        over_target_lh = over_target_lh?(player, hash[:farmer], match_duration)
        over_ally_support = over_ally_support?(player.assists + player.kills, ally_kills, hash[:killer])

        if over_target_lh && over_ally_support
          :op
        elsif over_target_lh
          :farmer
        else
          :killer
        end
      end

      def support_gameplay(player, ally_kills)
        hash = DotaSteam.configuration.gameplay_profilers_cache.json[:support]
        if over_ally_support?(player.assists, ally_kills, hash[:op])
          :op
        end
      end

      def mid_gameplay(player, ally_kills, match_duration)
        hash = DotaSteam.configuration.gameplay_profilers_cache.json[:mid]
        over_target_lh = over_target_lh?(player, hash[:farmer], match_duration)
        over_ally_support = over_ally_support?(player.assists + player.kills, ally_kills, hash[:killer])

        if over_ally_support && over_target_lh
          :op
        elsif over_ally_support
          :killer
        else
          :farmer
        end
      end

      def offlane_gameplay(player, ally_kills, match_duration)
        hash = DotaSteam.configuration.gameplay_profilers_cache.json[:offlane]
        over_target_lh = over_target_lh?(player, hash[:farmer], match_duration)
        over_ally_support = over_ally_support?(player.assists + player.kills, ally_kills, hash[:killer])

        if over_ally_support && over_target_lh
          :op
        elsif over_ally_support
          :killer
        else
          :farmer
        end
      end

      def jungle_gameplay(player, ally_kills, match_duration)
        hash = DotaSteam.configuration.gameplay_profilers_cache.json[:jungle]
        over_ally_support = over_ally_support?(player.assists + player.kills, ally_kills, hash[:killer])

        if over_ally_support
          :killer
        else
          :farmer
        end
      end

      def type_of_items(items)
        cache = DotaSteam.configuration.items_cache
        support = 0
        carry = 0
        items.each do |i|
          item = cache.get(i)
          if item && item[:role] == 1
            carry += 1
          elsif item && item[:role] == 2
            support += 1
          end
        end

        if carry > support
          :carry
        else
          :support
        end
      end

      def over_target_lh?(player, hash, match_duration)
        target_lh = lh_at_time(hash[:lh_target], hash[:lh_interval], match_duration)
        player.last_hits >= target_lh
      end

      def over_ally_support?(kills_and_assists, ally_kills, hash)
        kills_and_assists >= percent(ally_kills, hash[:assists_kills_percent])
      end
    end
  end
end