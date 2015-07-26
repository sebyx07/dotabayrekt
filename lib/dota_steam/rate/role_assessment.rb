require 'dota_steam/rate/point'
module DotaSteam
  module Rate
    class RoleAssessment
      attr_reader :kills_points, :deaths_points, :assists_points, :lh_points, :denies_points, :net_worth_points,
                  :xpm_points, :gpm_points, :level_advantage_points, :win_points

      def initialize(hash={})
        @kills_points = DotaSteam::Rate::Point.new(hash[:kills_points])
        @deaths_points = DotaSteam::Rate::Point.new(hash[:deaths_points])
        @assists_points = DotaSteam::Rate::Point.new(hash[:assists_points])
        @lh_points = DotaSteam::Rate::Point.new(hash[:lh_points])
        @denies_points = DotaSteam::Rate::Point.new(hash[:denies_points])
        @net_worth_points = DotaSteam::Rate::Point.new(hash[:net_worth_points])
        @xpm_points = DotaSteam::Rate::Point.new(hash[:xpm_points])
        @gpm_points = DotaSteam::Rate::Point.new(hash[:gpm_points])
        @level_advantage_points = DotaSteam::Rate::Point.new(hash[:level_advantage_points])
        @win_points = DotaSteam::Rate::Point.new(hash[:win_points])
      end
    end
  end
end