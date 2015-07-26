require 'spec_helper'
require 'dota_steam/profilers/player_profiler'

RSpec.describe DotaSteam::Profilers::PlayerProfiler do
  include DotaSteam::Profilers::PlayerProfiler
  describe '#role_by_hero' do
    it 'gets antimage and returns 1' do
      expect(role_by_hero(1)).to eq 1
    end
  end
end