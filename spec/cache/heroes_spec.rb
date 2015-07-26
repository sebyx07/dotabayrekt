require 'spec_helper'

RSpec.describe 'HeroesCache' do
  it 'finds antimage' do
    heroes_cache = DotaSteam.configuration.heroes_cache

    expect(heroes_cache.get(1)[:name]).to eq 'antimage'
  end
end