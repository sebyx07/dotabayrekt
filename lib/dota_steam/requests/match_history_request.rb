require 'dota_steam/requests/base_request'
require 'dota_steam/api_key_provider'

module DotaSteam
  module Requests
    class MatchHistoryRequest < DotaSteam::Requests::BaseRequest
      URL = 'http://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/V001/'.freeze

      def initialize(params ={})
        @params = params
      end

      def run
        req = HTTP.get(URL, params: {key: DotaSteam::ApiKeyProvider.get_key}.merge(@params))
        @status = req.status.to_i
        @body = req.body
        true
      end
    end
  end
end