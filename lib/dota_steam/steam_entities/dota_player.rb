module DotaSteam
  module SteamEntities
    class DotaPlayer
      attr_accessor :account_id, :player_slot, :hero_id

      #Static
      class << self
        def new_from_history(hash)
          player = self.new

          player.account_id = hash['account_id']
          player.player_slot = hash['player_slot']
          player.hero_id = hash['hero_id']

          player
        end
      end
    end
  end
end