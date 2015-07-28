require 'spec_helper'
require 'dota_steam/profilers/game_play'

RSpec.describe DotaSteam::Profilers::GamePlay do
  include DotaSteam::Profilers::GamePlay

  describe '#carry_gameplay' do
    it 'when it is farmer' do
      carry = double
      allow(carry).to receive(:gpm).and_return 800
      allow(carry).to receive(:kills).and_return 10

      expect(carry_gameplay(carry)).to eq :farmer
    end

    it 'when it is killer' do
      carry = double
      allow(carry).to receive(:gpm).and_return 700
      allow(carry).to receive(:kills).and_return 20

      expect(carry_gameplay(carry)).to eq :killer
    end

    it 'when it is farmer' do
      carry = double
      allow(carry).to receive(:gpm).and_return 800
      allow(carry).to receive(:kills).and_return 20

      expect(carry_gameplay(carry)).to eq :op
    end
  end
end