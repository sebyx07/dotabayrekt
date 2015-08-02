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
        DotaSteam.configuration.parse_logger.info "match_history #{@params}"
        HTTP.persistent('http://api.steampowered.com') do |http|

          initial_request = DotaSteam::Requests::MatchHistoryRequest.new(@params)
          last_match_id = nil
          begin
            initial_request.run(http)

            if initial_request.status == 200
              result = MultiJson.load(initial_request.body)['result']
              if result.nil? || result['status'] != 1
                @parse_errors.push http.uri
                @status = :fail
              else
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
                    DotaSteam.configuration.parse_logger.warn 'bad http status'
                    @status = :fail
                    @http_errors.push(@params)
                    last_match_id = nil
                  end
                end
              end
            else
              DotaSteam.configuration.parse_logger.warn 'bad http status'
              @http_errors.push(@params)
              @status = :fail
            end
          rescue HTTP::TimeoutError
            DotaSteam.configuration.parse_logger.warn 'timeout'
            @http_errors.push(@params)
            @status = :fail
            last_match_id = nil
          end
        end

        if @status == :pending
          @status = :done
        end

        @result = matches
        true
      end

      def parse_number_history(_limit)
        limit = _limit
        parse
        matches = []
        DotaSteam.configuration.parse_logger.info "match_history #{@params}"
        HTTP.persistent('http://api.steampowered.com') do |http|

          initial_request = DotaSteam::Requests::MatchHistoryRequest.new(@params)
          last_match_id = nil
          begin
            initial_request.run(http)

            if initial_request.status == 200
              result = MultiJson.load(initial_request.body)['result']
              if result.nil? || result['status'] != 1
                @parse_errors.push http.uri
                @status = :fail
              else
                if limit < result['matches'].size
                  matches += result['matches'][0..limit].map do |match_hash|
                    match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
                    DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash)
                    match
                  end
                else
                  matches += result['matches'].map do |match_hash|
                    match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
                    DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash)
                    match
                  end
                  limit -= result['matches'].size
                  results_remaining = result['results_remaining']

                  last_match_id = matches.last.match_id

                  while last_match_id != nil && results_remaining != nil && results_remaining != 0 && limit > 0
                    next_request = DotaSteam::Requests::MatchHistoryRequest.new(@params.merge({start_at_match_id: last_match_id}))
                    next_request.run(http)

                    if next_request.status == 200
                      result = MultiJson.load(next_request.body)['result']

                      temp = result['matches']
                      temp.shift

                      new_matches = []

                      if limit < temp.size
                        new_matches = temp[0..limit].map do |match_hash|
                          match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
                          DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash)
                          match
                        end
                        limit = 0
                      else
                        new_matches = temp[0..limit].map do |match_hash|
                          match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
                          DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash)
                          match
                        end
                        limit -= temp.size

                        matches += new_matches
                        if new_matches.last
                          last_match_id = new_matches.last.match_id
                        else
                          last_match_id = nil
                        end
                        results_remaining = result['results_remaining']
                      end
                    else
                      DotaSteam.configuration.parse_logger.warn 'bad http status'
                      @status = :fail
                      @http_errors.push(@params)
                      last_match_id = nil
                    end
                  end
                end
              end
            else
              DotaSteam.configuration.parse_logger.warn 'bad http status'
              @http_errors.push(@params)
              @status = :fail
            end
          rescue HTTP::TimeoutError
            DotaSteam.configuration.parse_logger.warn 'timeout'
            @http_errors.push(@params)
            @status = :fail
            last_match_id = nil
          end
        end

        if @status == :pending
          @status = :done
        end

        @result = matches
        true
      end


      def parse_until_match(match_id)
        found = false
        parse
        matches = []
        DotaSteam.configuration.parse_logger.info "match_history #{@params}"
        HTTP.persistent('http://api.steampowered.com') do |http|

          initial_request = DotaSteam::Requests::MatchHistoryRequest.new(@params)
          last_match_id = nil
          begin
            initial_request.run(http)

            if initial_request.status == 200
              result = MultiJson.load(initial_request.body)['result']
              if result.nil? || result['status'] != 1
                @parse_errors.push http.uri
                @status = :fail
              else
                tmp = result['matches'].map do |match_hash|
                  match = DotaSteam::SteamEntities::DotaMatch.new_from_history(match_hash)
                  DotaSteam::SteamEntities::DotaMatch.add_players_history(match, match_hash)
                  match
                end

                tmp.each do |m|
                  if m.match_id != match_id
                    matches.push(m)
                  else
                    found = true
                    break
                  end
                end

                results_remaining = result['results_remaining']

                last_match_id = matches.last.match_id

                while last_match_id != nil && results_remaining != nil && results_remaining != 0 && found == false
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

                    new_matches.each do |m|
                      if m.match_id != match_id
                        matches.push(m)
                      else
                        found = true
                        break
                      end
                    end
                    if new_matches.last
                      last_match_id = new_matches.last.match_id
                    else
                      last_match_id = nil
                    end
                    results_remaining = result['results_remaining']
                  else
                    DotaSteam.configuration.parse_logger.warn 'bad http status'
                    @status = :fail
                    @http_errors.push(@params)
                    last_match_id = nil
                  end
                end
              end
            else
              DotaSteam.configuration.parse_logger.warn 'bad http status'
              @http_errors.push(@params)
              @status = :fail
            end
          rescue HTTP::TimeoutError
            DotaSteam.configuration.parse_logger.warn 'timeout'
            @http_errors.push(@params)
            @status = :fail
            last_match_id = nil
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