require 'configurations'
require 'dota_steam/parsers/match_history_parser'
require 'dota_steam/parsers/match_details_parser'
require 'dota_steam/rate/role_assessment'
require 'dota_steam/rate/match_rate'

module DotaSteam
  include Configurations
  configuration_defaults do |c|
    c.api_keys = ['EE4B46697AAE3B64E5E4334E10E7AB0F']
  end
end