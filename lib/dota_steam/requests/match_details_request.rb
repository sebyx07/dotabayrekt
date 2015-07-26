require 'dota_steam/requests/base_request'
require 'dota_steam/api_key_provider'

module DotaSteam
  module Requests
    class MatchDetailsRequest < DotaSteam::Requests::BaseRequest
      URL = 'http://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/'.freeze

      def initialize(params ={})
        @params = params
      end

      def run(http=HTTP)
        req = http.get(URL, params: {key: DotaSteam::ApiKeyProvider.get_key}.merge(@params))
        @status = req.status.to_i
        @body = req.body

        http
      end
    end
  end
end