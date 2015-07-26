require 'spec_helper'
require 'dota_steam/rate/rating_functions'

describe DotaSteam::Rate::RatingFunctions do
  include DotaSteam::Rate::RatingFunctions

  describe '#kills' do
    it 'gives full points' do
      result = kills(50, 10, 1000, 5)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      result = kills(50, 10, 1000, 2)
      expect(result).to eq 400
    end

    it 'gives minimum points' do
      result = kills(50, 10, 1000, 0)
      expect(result).to eq 0
    end
  end

  describe '#deaths' do
    it 'gives points based on deaths' do
      result = deaths(200, 5)
      expect(result).to eq 1000
    end
  end

  describe '#assists' do
    it 'gives max points' do
      result = assists(50, 10, 1000, 5)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      result = assists(50, 10, 1000, 2)
      expect(result).to eq 400
    end

    it 'gives minimum points' do
      result = assists(50, 10, 1000, 0)
      expect(result).to eq 0
    end
  end

  describe '#lh' do
    it 'gives max points' do
      result = lh(100, 600, 3600, 1000, 600)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      result = lh(100, 600, 3600, 1000, 300)
      expect(result).to eq 500
    end

    it 'gives minimum points' do
      result = lh(100, 600, 3600, 1000, 0)
      expect(result).to eq 0
    end
  end

  describe '#denies' do
    it 'gives max points' do
      result = denies(50, 1000, 50)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      result = denies(50, 1000, 25)
      expect(result).to eq 500
    end

    it 'gives minimum points' do
      result = denies(50, 1000, 0)
      expect(result).to eq 0
    end
  end

  describe '#net_worth' do
    it 'gives max points' do
      result = net_worth(2000, 600, 3600, 1000, 12000)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      result = net_worth(2000, 600, 3600, 1000, 6000)
      expect(result).to eq 500
    end

    it 'gives minimum points' do
      result = net_worth(2000, 600, 3600, 1000, 0)
      expect(result).to eq 0
    end
  end

  describe '#xpm' do
    it 'gives max points' do
      result = xpm(800, 1000, 800)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      result = xpm(800, 1000, 400)
      expect(result).to eq 500
    end

    it 'gives minimum points' do
      result = xpm(800, 1000, 0)
      expect(result).to eq 0
    end
  end

  describe '#gpm' do
    it 'gives max points' do
      result = gpm(800, 1000, 800)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      result = gpm(800, 1000, 400)
      expect(result).to eq 500
    end

    it 'gives minimum points' do
      result = gpm(800, 1000, 0)
      expect(result).to eq 0
    end
  end

  describe '#win' do
    it 'gives points' do
      result = win(true, 1000)
      expect(result).to eq 1000
    end

    it 'does not give points' do
      result = win(false, 1000)
      expect(result).to eq 0
    end
  end

  describe '#lvl_advantage' do
    let(:enemy_lvlups){[{:players=>5, :sum=>1752}, {:players=>5, :sum=>3245}, {:players=>5, :sum=>5427}, {:players=>5, :sum=>7694}, {:players=>4, :sum=>7273}, {:players=>2, :sum=>3902}]}

    it 'gives max points' do
      player_lvlups = [230, 259, 290, 359, 419, 476, 548, 653, 840, 930, 1014, 1309, 1310, 1468, 1599, 1744, 1841, 1917, 1953]
      result = lvl_advantage(enemy_lvlups, 1000, player_lvlups, 200)
      expect(result).to eq 1000
    end

    it 'gives average points' do
      player_lvlups = [230, 259, 290, 359, 419, 476, 548, 653, 840, 930, 1014, 1309, 1310, 1468, 1599]
      result = lvl_advantage(enemy_lvlups, 1000, player_lvlups, 200)
      expect(result).to eq 800
    end

    it 'gives few points' do
      player_lvlups = [230, 259, 290, 359, 419, 476, 548, 653, 840]
      result = lvl_advantage(enemy_lvlups, 1000, player_lvlups, 200)
      expect(result).to eq 400
    end

    it 'gives minimum points' do
      player_lvlups = []
      result = lvl_advantage(enemy_lvlups, 1000, player_lvlups, 200)
      expect(result).to eq 0
    end
  end

  describe '#net_worth_at_time' do
    it 'returns 12000' do
      result = net_worth_at_time(2000, 600, 3600)
      expect(result).to eq 12000
    end
  end

  describe '#lh_at_time' do
    it 'returns 600' do
      result = lh_at_time(100, 600, 3600)
      expect(result).to eq 600
    end
  end
end