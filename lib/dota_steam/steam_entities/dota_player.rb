module DotaSteam
  module SteamEntities
    class DotaPlayer
      attr_accessor :account_id, :player_slot, :hero_id, :items, :bear_items, :kills, :deaths, :assists, :leaver_status,
                    :gold, :last_hits, :denies, :gpm, :xpm, :gold_spent, :hero_damage, :tower_damage, :hero_healing,
                    :level, :lvlups, :net_worth

      #Static
      class << self
        def new_from_history(hash)
          player = self.new

          player.account_id = hash['account_id']
          player.player_slot = hash['player_slot']
          player.hero_id = hash['hero_id']

          player
        end

        def new_from_full(hash)
          player = new_from_history(hash)
          add_items player, hash
          player.kills = hash['kills']
          player.deaths = hash['deaths']
          player.assists = hash['assists']
          player.leaver_status = hash['leaver_status']
          player.gold = hash['gold']
          player.last_hits = hash['last_hits']
          player.denies = hash['denies']
          player.gpm = hash['gold_per_min']
          player.xpm = hash['xp_per_min']
          player.gold_spent = hash['gold_spent']
          player.net_worth = player.gold + player.gold_spent
          player.hero_damage = hash['hero_damage']
          player.tower_damage = hash['tower_damage']
          player.hero_healing = hash['hero_healing']
          player.level = hash['level']
          add_lvlups player, hash
          player
        end

        protected
        def add_items(player, hash)
          player.items = []
          player.items.push(hash['item_0'], hash['item_1'], hash['item_2'], hash['item_3'], hash['item_4'], hash['item_5'])

          if hash['item_0'].nil?
            DotaSteam.configuration.parse_logger.warn 'player w/o items'
          end

          if player.hero_id == 80
            player.bear_items = []
            root = hash['additional_units'][0]
            player.bear_items.push(root['item_0'], root['item_1'], root['item_2'], root['item_3'], root['item_4'], root['item_5'])
          end
        end

        def add_lvlups(player, hash)
          player.lvlups = []
          ability_upgrades = hash['ability_upgrades']

          if ability_upgrades && ability_upgrades.respond_to?(:each)
            ability_upgrades.each do |ability|
              player.lvlups.push ability['time']
            end
          else
            DotaSteam.configuration.parse_logger.warn 'player w/o lvlups'
          end
        end
      end


      def radiant?
        player_slot < 128
      end

      def all_items
        i = []
        if items
          i += items
        end

        if bear_items
          i += bear_items
        end
        i
      end
    end
  end
end