require 'dota_steam/steam_entities/dota_player'

module DotaSteam
  module SteamEntities
    class DotaMatch
      attr_accessor :match_id, :match_seq_num, :start_time, :lobby_type, :radiant_team_id, :dire_team_id, :players, :radiant_win,
                    :duration, :tower_status_radiant, :tower_status_dire, :barracks_status_radiant, :barracks_status_dire,
                    :cluster, :first_blood_time, :human_players, :league_id, :positive_votes, :negative_votes,
                    :engine


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

        def new_from_full(hash)
          match = new_from_history hash
          match.radiant_win = hash['radiant_win']
          match.duration = hash['duration']
          match.tower_status_radiant = hash['tower_status_radiant']
          match.tower_status_dire = hash['tower_status_dire']
          match.barracks_status_radiant = hash['barracks_status_radiant']
          match.barracks_status_dire = hash['barracks_status_dire']
          match.cluster = hash['cluster']
          match.first_blood_time = hash['first_blood_time']
          match.human_players = hash['human_players']
          match.league_id = hash['leagueid']
          match.positive_votes = hash['positive_votes']
          match.negative_votes = hash['negative_votes']
          match.engine = hash['engine']
          match
        end

        def add_players_history(match, hash)
          if hash['players'] && hash['players'].respond_to?(:map)
            match.players = hash['players'].map do |player_hash|
              DotaSteam::SteamEntities::DotaPlayer.new_from_history(player_hash)
            end
          else
            match.players = []
            DotaSteam.configuration.parse_logger.warn 'w/o players'
          end
        end

        def add_players_full(match, hash)
          if hash['players'] && hash['players'].respond_to?(:map)
            match.players = hash['players'].map do |player_hash|
              DotaSteam::SteamEntities::DotaPlayer.new_from_full(player_hash)
            end
          else
            match.players = []
            DotaSteam.configuration.parse_logger.warn 'w/o players'
          end
        end
      end

      def radiant
        players.select { |player|  player.radiant? }
      end

      def dire
        players.select { |player|  !player.radiant? }
      end
    end
  end
end