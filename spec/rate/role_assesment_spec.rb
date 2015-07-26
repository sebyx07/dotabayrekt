require 'spec_helper'
require 'dota_steam/rate/role_assessment'

RSpec.describe DotaSteam::Rate::RoleAssessment do
  let(:hash){{
      kills_points: {target_percent: 20, max_points: 1000},
      deaths_points: {penalty_points: 300},
      assists_points: {target_percent: 10, max_points: 1000},
      lh_points: {target_per_time: 140, time_sec: 600, max_points: 1000},
      denies_points: {target_value: 30, max_points: 1000},
      net_worth_points: {target_per_time: 1000, time_sec: 300,  max_points: 1000},
      xpm_points: {target_value: 400, max_points: 1000},
      gpm_points: {target_value: 400, max_points: 1000},
      level_advantage_points: {penalty_points: 200, max_points: 1000},
      win_points: {max_points: 1000}
  }}

  let(:hash_with_0){{
      kills_points: {target_percent: 20, max_points: 1000, disabled: true},
      deaths_points: {penalty_points: 300},
      assists_points: {target_percent: 10, max_points: 1000},
      lh_points: {target_per_time: 140, time_sec: 600, max_points: 1000},
      denies_points: {target_value: 30, max_points: 1000},
      net_worth_points: {target_per_time: 1000, time_sec: 300,  max_points: 1000},
      xpm_points: {target_value: 400, max_points: 1000},
      gpm_points: {target_value: 400, max_points: 1000},
      level_advantage_points: {penalty_points: 200, max_points: 1000},
      win_points: {max_points: 1000}
  }}

  subject(:assessment){DotaSteam::Rate::RoleAssessment.new(hash)}

  context 'hash' do
    describe 'points' do
      it 'has kill points' do
        expect(assessment.kills_points.target_percent).to eq 20
        expect(assessment.kills_points.max_points).to eq 1000
      end

      it 'has death points' do
        expect(assessment.deaths_points.penalty_points).to eq 300
      end

      it 'has assists points' do
        expect(assessment.assists_points.target_percent).to eq 10
        expect(assessment.assists_points.max_points).to eq 1000
      end

      it 'has lh points' do
        expect(assessment.lh_points.target_per_time).to eq 140
        expect(assessment.lh_points.time_sec).to eq 600
        expect(assessment.lh_points.max_points).to eq 1000
      end

      it 'has denies points' do
        expect(assessment.denies_points.target_value).to eq 30
        expect(assessment.denies_points.max_points).to eq 1000
      end

      it 'has net worth points' do
        expect(assessment.net_worth_points.target_per_time).to eq 1000
        expect(assessment.net_worth_points.time_sec).to eq 300
        expect(assessment.net_worth_points.max_points).to eq 1000
      end

      it 'has xpm points' do
        expect(assessment.xpm_points.target_value).to eq 400
        expect(assessment.xpm_points.max_points).to eq 1000
      end

      it 'has gpm points' do
        expect(assessment.gpm_points.target_value).to eq 400
        expect(assessment.gpm_points.max_points).to eq 1000
      end

      it 'has level advantage points' do
        expect(assessment.level_advantage_points.penalty_points).to eq 200
        expect(assessment.level_advantage_points.max_points).to eq 1000
      end

      it 'has win points' do
        expect(assessment.win_points.max_points).to eq 1000
      end
    end
  end

  context 'hash_with_0' do
    it 'has kill points' do
      ass = DotaSteam::Rate::RoleAssessment.new(hash_with_0)
      expect(ass.kills_points.disabled).to be true
    end
  end
end