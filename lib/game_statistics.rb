require 'csv'
require_relative 'game.rb'

class GameStatistics
    attr_reader :game_data,
                :team_data,
                :stat_tracker

    def initialize(game_data, team_data, stat_tracker)
        @game_data = game_data       
        @team_data = team_data
        @stat_tracker = stat_tracker
    end

    def percent_home_wins

    end

    def perecent_vistor_wins

    end

    def highest_total_score

    end

    def lowest_total_score

    end

    def average_goals_per_game
        total_goals = 0
        games = 0
        @game_data.each do |game|
            total_goals += game.away_goals.to_i + game.home_goals.to_i
            games += 1
        end
        average_goals = total_goals / games.to_f
        average_goals.round(2)
        @stat_tracker.team_name(team_id)
    end

    def total_goals_by_season
        total_goals = Hash.new(0)
        @game_data.each do |game|
           total_goals[game.season] += (game.away_goals.to_i + game.home_goals.to_i)
        end
        total_goals
        @stat_tracker.team_name(team_id)
    end
       
    def average_goals_by_season
        average_goals = Hash.new(0)
       total_goals_by_season.each do |season, total_goals|
            average_goals[season] = (total_goals.to_f / count_of_games_by_season[season]).round(2)
       end
       average_goals
       @stat_tracker.team_name(team_id)
    end 

    def count_of_games_by_season
        count_by_season = Hash.new(0)
        @game_data.each do |game|
            count_by_season[game.season] += 1
        end
        count_by_season
        @stat_tracker.team_name(team_id)
    end
end
