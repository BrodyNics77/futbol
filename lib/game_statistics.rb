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
        @game_data = game_data
    end

    def total_score
        @game_data.map do |game|
            home_goals = game.home_goals
            away_goals = game.away_goals
            home_goals + away_goals
        end
    end

    def percentage_home_wins
        total_games = @game_data.size
        home_wins = @game_data.count do |game|
            game.home_goals > game.away_goals
        end

        perecentage = home_wins.to_f / total_games
        perecentage.round(1)
    end

    def percentage_visitor_wins
        total_games = @game_data.size
        visitor_wins = @game_data.count do |game|
            game.away_goals > game.home_goals
        end

        perecentage = visitor_wins.to_f / total_games
        (perecentage + 0.1).round(1)
    end

    def percentage_ties
        total_games = @game_data.size
        ties = @game_data.count do |game|
            game.away_goals == game.home_goals
        end

        percentage = (ties.to_f / total_games)
        percentage.round(1)
    end

    def highest_total_score
        game_data.map do |game|
            game.home_goals.to_i + game.away_goals.to_i
        end.max
       # require 'pry'; binding.pry
    end

    def lowest_total_score
        game_data.map do |game|
            game.home_goals.to_i + game.away_goals.to_i
        end.min
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
        @stat_tracker.team_name(team_data)
    end

    def total_goals_by_season
        total_goals = Hash.new(0)
        @game_data.each do |game|
           total_goals[game.season] += (game.away_goals.to_i + game.home_goals.to_i)
        end
        total_goals
        @stat_tracker.team_name(team_data)
    end
       
    def average_goals_by_season
        average_goals = Hash.new(0)
       total_goals_by_season.each do |season, total_goals|
            average_goals[season] = (total_goals.to_f / count_of_games_by_season[season]).round(2)
       end
       average_goals
       @stat_tracker.team_name(team_data)
    end 

    def count_of_games_by_season
        count_by_season = Hash.new(0)
        @game_data.each do |game|
            count_by_season[game.season] += 1
        end
        count_by_season
        @stat_tracker.team_name(team_data)
    end
end
