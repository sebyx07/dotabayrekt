require 'spec_helper'
require 'dota_steam/profilers/player_profiler'

RSpec.describe DotaSteam::Profilers::PlayerProfiler do
  include DotaSteam::Profilers::PlayerProfiler
  describe '#role_by_hero' do
    it 'gets antimage and returns 1' do
      expect(role_by_hero(1)).to eq 1
    end
  end

  describe '#profile_by_gameplay' do
    context 'carry' do
      before do
        @carry_farmer = double
        allow(@carry_farmer).to receive(:last_hits).and_return 100
        allow(@carry_farmer).to receive(:kills).and_return 5
        allow(@carry_farmer).to receive(:assists).and_return 0

        @carry_killer = double
        allow(@carry_killer).to receive(:last_hits).and_return 40
        allow(@carry_killer).to receive(:kills).and_return 10
        allow(@carry_killer).to receive(:assists).and_return 10

        @carry_op = double
        allow(@carry_op).to receive(:last_hits).and_return 100
        allow(@carry_op).to receive(:kills).and_return 20
        allow(@carry_op).to receive(:assists).and_return 0
      end
      it 'returns carry' do
        expect(profile_by_gameplay(1, @carry_farmer, 30, 600)).to eq [:carry, :farmer]
        expect(profile_by_gameplay(1, @carry_killer, 30, 600)).to eq [:carry, :killer]
        expect(profile_by_gameplay(1, @carry_op, 30, 600)).to eq [:carry, :op]
      end
    end

    context 'support' do
      before do
        @support_hard = double
        allow(@support_hard).to receive(:assists).and_return 5
        allow(@support_hard).to receive(:all_items).and_return [78, 78]

        @support_core = double
        allow(@support_core).to receive(:assists).and_return 10
        allow(@support_core).to receive(:all_items).and_return [141, 141]

        @support_op = double
        allow(@support_op).to receive(:assists).and_return 10
        allow(@support_op).to receive(:all_items).and_return [78, 78]
      end

      it 'return support' do
        expect(profile_by_gameplay(2, @support_hard, 15, 600)).to eq [:support, :hard]
        expect(profile_by_gameplay(2, @support_core, 15, 600)).to eq [:support, :core]
        expect(profile_by_gameplay(2, @support_op, 15, 600)).to eq [:support, :op]
      end
    end

    context 'mid' do
      before do
        @mid_farmer = double
        allow(@mid_farmer).to receive(:last_hits).and_return 100
        allow(@mid_farmer).to receive(:kills).and_return 5
        allow(@mid_farmer).to receive(:assists).and_return 4

        @mid_killer = double
        allow(@mid_killer).to receive(:last_hits).and_return 0
        allow(@mid_killer).to receive(:kills).and_return 10
        allow(@mid_killer).to receive(:assists).and_return 10

        @mid_op = double
        allow(@mid_op).to receive(:last_hits).and_return 100
        allow(@mid_op).to receive(:kills).and_return 10
        allow(@mid_op).to receive(:assists).and_return 10
      end

      it 'mid' do
        expect(profile_by_gameplay(3, @mid_farmer, 30, 600)).to eq [:mid, :farmer]
        expect(profile_by_gameplay(3, @mid_killer, 30, 600)).to eq [:mid, :killer]
        expect(profile_by_gameplay(3, @mid_op, 30, 600)).to eq [:mid, :op]
      end
    end


    context 'offlane' do
      before do
        @offlane_farmer = double
        allow(@offlane_farmer).to receive(:last_hits).and_return 100
        allow(@offlane_farmer).to receive(:kills).and_return 5
        allow(@offlane_farmer).to receive(:assists).and_return 4

        @offlane_killer = double
        allow(@offlane_killer).to receive(:last_hits).and_return 0
        allow(@offlane_killer).to receive(:kills).and_return 10
        allow(@offlane_killer).to receive(:assists).and_return 10

        @offlane_op = double
        allow(@offlane_op).to receive(:last_hits).and_return 100
        allow(@offlane_op).to receive(:kills).and_return 10
        allow(@offlane_op).to receive(:assists).and_return 10
      end

      it 'offlane' do
        expect(profile_by_gameplay(4, @offlane_farmer, 30, 600)).to eq [:offlane, :farmer]
        expect(profile_by_gameplay(4, @offlane_killer, 30, 600)).to eq [:offlane, :killer]
        expect(profile_by_gameplay(4, @offlane_op, 30, 600)).to eq [:offlane, :op]
      end
    end


    context 'jungle' do
      before do
        @jungle_farmer = double
        allow(@jungle_farmer).to receive(:last_hits).and_return 100
        allow(@jungle_farmer).to receive(:kills).and_return 5
        allow(@jungle_farmer).to receive(:assists).and_return 4

        @jungle_killer = double
        allow(@jungle_killer).to receive(:last_hits).and_return 0
        allow(@jungle_killer).to receive(:kills).and_return 10
        allow(@jungle_killer).to receive(:assists).and_return 10

      end

      it 'jungle' do
        expect(profile_by_gameplay(5, @jungle_farmer, 30, 600)).to eq [:jungle, :farmer]
        expect(profile_by_gameplay(5, @jungle_killer, 30, 600)).to eq [:jungle, :killer]
      end
    end


  end
end