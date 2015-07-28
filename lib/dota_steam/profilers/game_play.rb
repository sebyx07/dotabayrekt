require 'dota_steam/rate/rating_functions'
module DotaSteam
  module Profilers
    module GamePlay
      include DotaSteam::Rate::RatingFunctions
      CARRY={
         farmer: {
             gpm: 800
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

      def carry_gameplay(player)
        hash = CARRY
        if player.gpm >= hash[:farmer][:gpm] && player.kills >= hash[:killer][:kills]
          :op
        elsif player.gpm >= hash[:farmer][:gpm]
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