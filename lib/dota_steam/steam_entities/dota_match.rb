require 'dota_steam/steam_entities/dota_player'

module DotaSteam
  module SteamEntities
    class DotaMatch
      attr_accessor :match_id, :match_seq_num, :start_time, :lobby_type, :radiant_team_id, :dire_team_id, :players


      def to_s
        "match_id: #{match_id} match_seq_num: #{match_seq_num} start_time: #{start_time} lobby_type: #{lobby_type} " +
        "radiant_team_id: #{radiant_team_id} dire_team_id: #{dire_team_id}"
      end

      #Static
      class << self
        def new_from_history(hash)
          match = self.new

          match.match_id = hash['match_id']
          match.match_seq_num = hash['match_seq_num']
          match.start_time = hash['start_time']
          match.lobby_type = hash['lobby_type']
          match.radiant_team_id = hash['radiant_team_id']
          match.dire_team_id = hash['dire_team_id']

          match
        end

        def add_players(match, hash)
          match.players = hash['players'].map do |player_hash|
            DotaSteam::SteamEntities::DotaPlayer.new_from_history(player_hash)
          end
        end
      end
    end
  end
end