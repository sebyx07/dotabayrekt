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
             kills: 15
         }
      }

      SUPPORT={
          op:{
              assits_percent: 60
          }
      }

      MID ={
          farmer:{
              lh_target: 60,
              lh_interval: 600
          },
          killer:{
              kills_and_assits: 20
          }
      }

      def carry_gameplay(player, match_duration)
        hash = CARRY
        farmer = hash[:farmer]
        target_lh = lh_at_time(farmer[:lh_target], farmer[:lh_interval], match_duration)
        over_target_lh = player.last_hits >= target_lh

        if over_target_lh && player.kills > hash[:killer][:kills]
          :op
        elsif over_target_lh
          :farmer
        else
          :killer
        end
      end

      def support_gameplay(player, ally_kills)
        hash = SUPPORT
        if(player.assists > percent(ally_kills, hash[:op][:assits_percent]))
          return :op
        end
      end

      def mid_gameplay(player, match_duration)
        hash = MID
        farmer = hash[:farmer]
        target_lh = lh_at_time(farmer[:lh_target], farmer[:lh_interval], match_duration)
        over_target_lh = player.last_hits >= target_lh

        total_ganks = player.kills  + player.assists
        if total_ganks >= hash[:killer][:kills_and_assits] && over_target_lh
          :op
        elsif total_ganks >= hash[:killer][:kills_and_assits]
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
    end
  end
end