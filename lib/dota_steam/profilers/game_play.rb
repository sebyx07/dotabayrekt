module DotaSteam
  module Profilers
    module GamePlay
      CARRY={
         farmer: {
             gpm: 800
         },
         killer:{
             kills: 15
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
    end
  end
end