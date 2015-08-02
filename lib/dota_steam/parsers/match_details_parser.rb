require 'dota_steam/parsers/base_parser'
require 'dota_steam/requests/match_details_request'
require 'dota_steam/steam_entities/dota_match'
require 'multi_json'
require 'http'

module DotaSteam
  module Parsers
    class MatchDetailsParser < DotaSteam::Parsers::BaseParser
      def initialize(params = {})
        @params = params
      end

      def parse_matches(match_ids)
        parse
        matches = []
        HTTP.persistent('http://api.steampowered.com') do |http|
          while match_ids.size > 0
            match_id = match_ids.pop
            DotaSteam.configuration.parse_logger.info "m: #{match_id}"
            begin
              request = DotaSteam::Requests::MatchDetailsRequest.new(@params.merge(match_id: match_id))
              request.run(http)
              if request.status == 200
                result = MultiJson.load(request.body)['result']
                if result.nil? || result['error']
                  @parse_errors.push match_id
                  @status = :fail
                else
                  match = DotaSteam::SteamEntities::DotaMatch.new_from_full(result)
                  DotaSteam::SteamEntities::DotaMatch.add_players_full(match, result)
                  matches.push(match)
                  @parse_errors.push match_id
                end
              else
                DotaSteam.configuration.parse_logger.warn 'bad http status'
                @http_errors.push(match_id)
                @status = :fail
              end
            rescue HTTP::TimeoutError
              DotaSteam.configuration.parse_logger.warn 'timeout'
              @http_errors.push(match_id)
            end
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