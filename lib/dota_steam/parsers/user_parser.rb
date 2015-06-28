require 'dota_steam/parsers/base_parser'
require 'dota_steam/requests/steam_user_request'
require 'dota_steam/steam_entities/steam_user'

module DotaSteam
  module Parsers
    class UserParser < DotaSteam::Parsers::BaseParser
      def initialize(_steam_ids)
        steam_ids = []
        if _steam_ids.is_a? Array
          steam_ids += _steam_ids
        else
          steam_ids << _steam_ids
        end
        @steam_ids = steam_ids
      end

      def parse
        super
        users = []
        request = DotaSteam::Requests::SteamUserRequest.new(@steam_ids)
        request.run
        if request.status.to_i == 200
          json = JSON.parse(request.body)
          players = json['response']['players']


          users = players.map{|player_hash| DotaSteam::SteamEntities::SteamUser.new_from_hash(player_hash) }
          @status = :done
        else
          @status = :fail
        end

        users
      end
    end
  end
end