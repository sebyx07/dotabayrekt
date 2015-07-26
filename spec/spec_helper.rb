require 'pry'
require 'dota_steam'
require 'webmock/rspec'

module DotaSteam
  configuration_defaults do |c|
    c.api_keys = ['EE4B46697AAE3B64E5E4334E10E7AB0F']
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