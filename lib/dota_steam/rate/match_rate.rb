require 'dota_steam/rate/team_stats'
require 'dota_steam/rate/rating_functions'

module DotaSteam
  module Rate

    class MatchRate
      include DotaSteam::Rate::RatingFunctions
      attr_accessor :match, :radiant_stats, :dire_stats, :player_ratings

      def initialize(match, assessments)
        @match = match
        @assessments = assessments
        @player_ratings = []
      end

      def rate
        @radiant_stats = DotaSteam::Rate::TeamStats.new(@match.radiant, @match.radiant_win)
        @dire_stats = DotaSteam::Rate::TeamStats.new(@match.dire, !@match.radiant_win)

        @match.radiant.each do |player|
          @player_ratings.push(rate_player(player, @radiant_stats, @dire_stats, @assessments[player]))
        end

        @match.dire.each do |player|
          @player_ratings.push(rate_player(player, @dire_stats, @radiant_stats, @assessments[player]))
        end

        self
      end

      def rate_player(player, ally_stats, enemy_stats, assessment)
        kills_score =  calc_kills_score(player, ally_stats, enemy_stats, assessment)
        deaths_score = calc_deaths_score(player, assessment)
        assists_score = calc_assists_score(player, ally_stats, assessment)
        lh_score = calc_lh_score(player, assessment)
        denies_score = calc_denies_score(player, assessment)
        net_worth_score = calc_net_worth_score(player, assessment)
        gpm_score = calc_gpm_score(player, assessment)
        xpm_score = calc_xpm_score(player, assessment)
        level_advantage_score = calc_level_advantage_score(player, enemy_stats, assessment)
        win_score = calc_win_score(ally_stats, assessment)
        final_score = kills_score + deaths_score + assists_score + lh_score + denies_score + net_worth_score +  gpm_score +
            xpm_score + level_advantage_score + win_score
        PlayerRate.new(player.account_id,
         {
           kills_score: kills_score,
           deaths_score: deaths_score,
           assists_score: assists_score,
           lh_score: lh_score,
           denies_score: denies_score,
           net_worth_score: net_worth_score,
           gpm_score: gpm_score,
           xpm_score: xpm_score,
           level_advantage_score: level_advantage_score,
           win_score: win_score,
           final_score: final_score
         }
        )
      end

      def calc_kills_score(player, ally_stats, enemy_stats, assessment)
        ass_kills = assessment.kills_points
        if check_if_disabled(ass_kills)
          return 0
        end
        match_kills = ally_stats.kills + enemy_stats.kills
        kills(match_kills, ass_kills.target_percent, ass_kills.max_points, player.kills)
      end

      def calc_deaths_score(player, assessment)
        ass_deaths = assessment.deaths_points
        if check_if_disabled(ass_deaths)
          return 0
        end
        -1 * deaths(ass_deaths.penalty_points, player.deaths)
      end

      def calc_assists_score(player, ally_stats, assessment)
        ass_assists = assessment.assists_points
        if check_if_disabled(ass_assists)
          return 0
        end
        assists(ally_stats.kills, ass_assists.target_percent,
                ass_assists.max_points, player.assists)
      end

      def calc_lh_score(player, assessment)
        ass_lh = assessment.lh_points
        if check_if_disabled(ass_lh)
          return 0
        end
        lh(ass_lh.target_per_time, ass_lh.time_sec, @match.duration, ass_lh.max_points, player.last_hits)
      end

      def calc_denies_score(player, assessment)
        ass_denies = assessment.denies_points
        if check_if_disabled(ass_denies)
          return 0
        end
        denies(ass_denies.target_value, ass_denies.max_points, player.denies)
      end

      def calc_net_worth_score(player, assessment)
        ass_net_worth = assessment.net_worth_points
        if check_if_disabled(ass_net_worth)
          return 0
        end
        net_worth(ass_net_worth.target_per_time, ass_net_worth.time_sec, @match.duration, ass_net_worth.max_points,
                  player.net_worth)
      end

      def calc_gpm_score(player, assessment)
        ass_gpm = assessment.gpm_points
        if check_if_disabled(ass_gpm)
          return 0
        end
        gpm(ass_gpm.target_value, ass_gpm.max_points, player.gpm)
      end

      def calc_xpm_score(player, assessment)
        ass_xpm = assessment.xpm_points
        if check_if_disabled(ass_xpm)
          return 0
        end
        xpm(ass_xpm.target_value, ass_xpm.max_points, player.xpm)
      end

      def calc_level_advantage_score(player, enemy_stats, assessment)
        ass_level_advantage = assessment.level_advantage_points
        if check_if_disabled(ass_level_advantage)
          return 0
        end
        lvl_advantage(enemy_stats.lvlups, ass_level_advantage.max_points, player.lvlups, ass_level_advantage.penalty_points)
      end

      def calc_win_score(ally_stats, assessment)
        ass_win = assessment.win_points
        if check_if_disabled(ass_win)
          return 0
        end
        win(ally_stats.win, ass_win.max_points)
      end

      def check_if_disabled(points)
        if points.disabled
          true
        else
          false
        end
      end
    end

    class PlayerRate
      attr_reader :account_id, :final_score, :kills_score, :deaths_score, :assists_score, :lh_score, :denies_score,
                  :net_worth_score, :xpm_score, :gpm_score, :level_advantage_score, :win_score

      def initialize(account_id, hash)
        @account_id = account_id
        @final_score = hash[:final_score]
        @kills_score = hash[:kills_score]
        @deaths_score = hash[:deaths_score]
        @assists_score = hash[:assists_score]
        @lh_score = hash[:lh_score]
        @denies_score = hash[:denies_score]
        @net_worth_score = hash[:net_worth_score]
        @xpm_score = hash[:xpm_score]
        @gpm_score = hash[:gpm_score]
        @level_advantage_score = hash[:level_advantage_score]
        @win_score = hash[:win_score]
      end
    end
  end
end