require 'dota_steam/rate/rating_functions'
module DotaSteam
  module Profilers
    module GamePlay
      include DotaSteam::Rate::RatingFunctions
      CARRY={
         farmer: {
             lh_target: 100,
             lh_interval: 600
         },
         killer:{
             assists_kills_percent: 30
         }
      }

      SUPPORT={
          op:{
              assists_kills_percent: 60
          }
      }

      MID ={
          farmer:{
              lh_target: 60,
              lh_interval: 600
          },
          killer:{
              assists_kills_percent: 40
          }
      }

      OFFLANE ={
          farmer:{
              lh_target: 40,
              lh_interval: 600
          },
          killer:{
              assists_kills_percent: 50
          }
      }

      JUNGLE ={
          farmer:{
              lh_target: 40,
              lh_interval: 600
          },
          killer:{
              assists_kills_percent: 50
          }
      }

      def carry_gameplay(player, ally_kills, match_duration)
        hash = CARRY
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
        hash = SUPPORT
        if over_ally_support?(player.assists, ally_kills, hash[:op])
          return :op
        end
      end

      def mid_gameplay(player, ally_kills, match_duration)
        hash = MID
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
        hash = OFFLANE
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
        hash = JUNGLE
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