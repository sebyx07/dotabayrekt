require 'pry'
require 'dota_steam'
require 'webmock/rspec'
require 'logger'

module DotaSteam
  logger = Logger.new('./spec/spec.log', 'daily')
  configuration_defaults do |c|
    c.api_keys = ['EE4B46697AAE3B64E5E4334E10E7AB0F']
    c.heroes_cache = DotaSteam::Cache::BaseCache.new('./json/heroes.json', :heroes)
    c.items_cache = DotaSteam::Cache::BaseCache.new('./json/items.json', :items)
    c.gameplay_profilers_cache = DotaSteam::Cache::BaseCache.new('./json/game_play_profiler.json', :profilers)
    c.parse_logger = logger
    c.rate_logger = logger
  end
end

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end