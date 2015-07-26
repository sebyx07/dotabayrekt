require 'dota_steam/parsers/base_parser'
require 'dota_steam/requests/match_history_request'
require 'dota_steam/steam_entities/dota_match'
require 'multi_json'
require 'http'

module DotaSteam
  module Parsers
    class MatchHistoryParser < DotaSteam::Parsers::BaseParser
      def initialize(params = {})
        @params = params
      end

      def parse_full_history
        parse
        matches = []

        HTTP.persistent('http://api.steampowered.com') do |http|

          initial_request = DotaSteam::Requests::MatchHistoryRequest.new(@params)

          initial_request.run(http)

          if initial_request.status == 200

            result = MultiJson.load(initial_request.body)['result']

            matches += result['matches'].map do |match_hash|
              match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
              DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash)
              match
            end
            results_remaining = result['results_remaining']

            last_match_id = matches.last.match_id

            while last_match_id != nil && results_remaining != nil && results_remaining != 0
              next_request = DotaSteam::Requests::MatchHistoryRequest.new(@params.merge({start_at_match_id: last_match_id}))
              next_request.run(http)

              if next_request.status == 200
                result = MultiJson.load(next_request.body)['result']

                temp = result['matches']
                temp.shift

                new_matches = temp.map do |match_hash|
                  match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
                  DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash)
                  match
                end
                matches += new_matches
                if new_matches.last
                  last_match_id = new_matches.last.match_id
                else
                  last_match_id = nil
                end
                results_remaining = result['results_remaining']
              else
                @status = :fail
                last_match_id = nil
              end
            end
          else
            @status = :fail
          end
        end

        if @status == :pending
          @status = :done
        end

        @result = matches
        true
      end
    end
  end
end