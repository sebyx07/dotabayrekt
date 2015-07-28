require 'configurations'
require 'dota_steam/parsers/match_history_parser'
require 'dota_steam/parsers/match_details_parser'
require 'dota_steam/rate/role_assessment'
require 'dota_steam/rate/match_rate'
require 'dota_steam/cache/base_cache'
require '../lib/dota_steam/profilers/player_profiler'

module DotaSteam
  include Configurations
end