require 'dota_steam/requests/base_request'
require 'dota_steam/api_key_provider'

module DotaSteam
  module Requests
    class SteamUserRequest < DotaSteam::Requests::BaseRequest
      URL = 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/'.freeze

      def initialize(_steam_ids)
        @steam_ids = _steam_ids
      end

      def run
        req = HTTP.get(URL, params: {key: DotaSteam::ApiKeyProvider.get_key, steamids: @steam_ids.join(',')})
        @status = req.status.to_i
        @body = req.body
        true
      end
    end
  end
end