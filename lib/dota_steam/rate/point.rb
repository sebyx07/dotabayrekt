module DotaSteam
  module Rate
    class Point
      attr_reader :target_value, :target_percent, :penalty_points, :max_points, :target_per_time, :time_sec, :disabled
      def initialize(hash = {})
        @target_value = hash[:target_value]
        @target_percent = hash[:target_percent]
        @penalty_points = hash[:penalty_points]
        @max_points = hash[:max_points]
        @target_per_time = hash[:target_per_time]
        @time_sec = hash[:time_sec]
        @disabled = hash[:disabled]
      end
    end
  end
end