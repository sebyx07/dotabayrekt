require 'spec_helper'

RSpec.describe 'HeroesCache' do
  it 'finds antimage' do
    items_cache = DotaSteam.configuration.items_cache

    expect(items_cache.get(104)[:name]).to eq 'dagon'
  end
end