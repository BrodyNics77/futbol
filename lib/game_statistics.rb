require 'csv'
require 'game.rb'

class GameStatistics
    attr_reader :game_data,
                :team_data,
                :stat_tracker

    def initialize(game_data, team_data, stat_tracker)
        @game_data = game_data
        @team_data = team_data
        @stat_tracker = stat_tracker
    end

    def percentage_home_wins
        total_games = @game_data.size
        home_wins = @game_data.count do |game|
            game.home_goals > game.away_goals
        end

        perecentage = home_wins.to_f / total_games
        perecentage.round(1)
    end

    def percentage_vistor_wins
        total_games = @game_data.size
        visitor_wins = @game_data.count do |game|
            game.away_goals > game.home_goals
        end

        perecentage = away_wins.to_f / total_games
        perecentage.round(1)
    end

    def total_score
        @games_data.map do |game|
            home_goals = game.home_goals
            away_goals = gane.away_goals
            home_goals + away_goals
        end
    end

    def highest_total_score
        totalscore.max
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
    end
end
