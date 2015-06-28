require 'http'

module DotaSteam
  module Requests
    class SteamUserRequest < DotaSteam::Requests::BaseRequest
      URL = 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/'

      def initialize(_steam_ids)
        steam_ids = []
        if _steam_ids.is_a? Array
          steam_ids += _steam_ids
        else
          steam_ids << _steam_ids
        end
        
        @steam_ids = steam_ids
      end

      def run
      end

    end
  end
end