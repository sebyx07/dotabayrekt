require 'dota_steam/parsers/base_parser'
require 'dota_steam/requests/match_history_request'
require 'dota_steam/steam_entities/dota_match'
require 'multi_json'
require 'benchmark'

module DotaSteam
  module Parsers
    class MatchHistoryParser < DotaSteam::Parsers::BaseParser
      def initialize(params = {})
        @params = params
      end

      def parse_full_history
        parse
        matches = []

        initial_request = DotaSteam::Requests::MatchHistoryRequest.new(@params)
        initial_request.run


        if initial_request.status == 200

          result = JSON.parse(initial_request.body)['result']

          matches += result['matches'].map {|match_hash| DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)}
          results_remaining = result['results_remaining']

          last_match_id = matches.last.match_id

          while last_match_id != nil && results_remaining != nil && results_remaining != 0
            next_request = DotaSteam::Requests::MatchHistoryRequest.new(@params.merge({start_at_match_id: last_match_id}))
            next_request.run

            if next_request.status == 200
              result = MultiJson.load(next_request.body)['result']

              temp = result['matches']
              temp.shift

              new_matches = temp.map {|match_hash| DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)}
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

        if @status == :pending
          @status = :done
        end

        @result = matches
        true
      end
    end
  end
end