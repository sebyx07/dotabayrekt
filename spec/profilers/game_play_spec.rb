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

  describe '#support_game_play' do
    it 'when it is hard' do
      support = double
      allow(support).to receive(:assists).and_return 10

      expect(support_gameplay(support, 15)).to eq :op
    end
  end

  describe '#type_of_items' do
    it 'when more support items' do
      items = [78, 78, 78, 42, 42 ,42]
      expect(type_of_items(items)).to eq :support
    end

    it 'when more carry items' do
      items = [141, 141, 141, 141, 0 ,0]
      expect(type_of_items(items)).to eq :carry
    end
  end
end