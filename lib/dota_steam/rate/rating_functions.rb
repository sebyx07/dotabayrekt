module DotaSteam
  module Rate
    module RatingFunctions
      def kills(match_kills, target_percent, max_points, kills)
        max_kills = percent(match_kills, target_percent)
        percent_points(max_kills, max_points, kills)
      end

      def deaths(penalty_pts, deaths)
        deaths * penalty_pts
      end

      def assists(ally_kills, target_percent, max_points, assists)
        max_assists = percent(ally_kills, target_percent)
        percent_points(max_assists, max_points, assists)
      end

      def lh(lh, interval, match_duration, max_pts, last_hits)
        target_lh = lh_at_time(lh, interval, match_duration)
        percent_points(target_lh, max_pts, last_hits)
      end

      def denies(target_denies, max_pts, denies)
        percent_points(target_denies, max_pts, denies)
      end

      def net_worth(gold, interval, match_duration, max_pts, net_worth)
        target_net_worth = net_worth_at_time(gold, interval, match_duration)
        percent_points(target_net_worth, max_pts, net_worth)
      end

      def xpm(target_gpm, max_pts, xpm)
        percent_points(target_gpm, max_pts, xpm)
      end

      def gpm(target_gpm, max_pts, gpm)
        percent_points(target_gpm, max_pts, gpm)
      end

      def lvl_advantage(enemy_team_level_ups, max_pts, level_ups, penalty)
        penalties = 0
        enemy_team_level_ups.each_with_index do |enemy, i|
          player_level = level_ups[i * 3]
          unless player_level
            penalties += penalty * (enemy_team_level_ups.size - i)
            break
          end
          average = enemy[:sum] / enemy[:players]
          if player_level > average
            penalties += penalty
          end
        end
        result = max_pts - penalties

        if result < 0
          result = 0
        end
        result
      end

      def win(win, max_pts)
        if win
          max_pts
        else
          0
        end
      end

      def percent(value, percent)
        percent * value / 100.0
      end

      def percent_points(max_value, max_points, current_value)
        res = current_value * max_points / max_value
        if res > max_points
          res = max_points
        end
        res.to_i
      end

      def net_worth_at_time(gold, interval, match_duration)
        time = match_duration / interval
        gold * time
      end

      def lh_at_time(lh, interval, match_duration)
        time = match_duration / interval
        lh * time
      end
    end
  end
end