require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'
class StatTracker
    attr_reader :locations,
                #:league_statistics
                :games,
                :teams,
                :game_teams
    
    def self.from_csv(locations)
        StatTracker.new(locations)
    end

    def initialize(locations)
        @games              = create_objects(locations[:games], Game)
        @teams              = create_objects(locations[:teams], Team)
        @game_teams         = create_objects(locations[:game_teams], GameTeam)
        #require 'pry'; binding.pry
        @league_statistics = LeagueStatistics.new(@games, @teams, @game_teams, self)
        #@team_statistics    = TeamStatistic.new(@teams, self)
    end

    
    def create_objects(path, type)
        csv_table = CSV.parse(File.read(path), headers: true)
        csv_table.map do |row|
            #require 'pry'; binding.pry
            type.new(row)
        end
    end
    
    def count_of_teams
         @team_statistics.count_of_teams
    end

    def team_name(team_id)
        @teams.find { |team| team.team_id == team_id}.team_name
    end

    #puts'--------------------Game Statistics--------------------'

    def highest_total_score
        @stat_tracker.name(highest_total_score_id)
    end

    def lowest_total_score
        @stat_tracker.name(lowest_total_score_id)
    end

    def percentage_home_wins
        @stat_tracker.name(percentage_home_wins)
    end

    def  percentage_visitor_wins
        @stat_tracker.name(percentage_visitor_wins)
    end

    def count_of_games_by_season(season)
        @stat_tracker.name(count_of_games_by_season_id(season))
    end

    def average_goals_per_game
        @stat_tracker.name(average_goals_per_game)
    end

    def average_goals_by_season
        @stat_tracker.name(average_goals_by_season)
    end

    #puts'--------------------League Statistics--------------------'

    def count_of_teams
        @stat_tracker.team_name(count_of_teams)
      end
    
    def best_offense
        @stat_tracker.team_name(best_offense)
    end

    def worst_offense
        @stat_tracker.team_name(worst_offense)
    end

    def highest_scoring_visitor
        @stat_tracker.team_name(highest_scoring_visitor)
    end

    def highest_scoring_home_team
        @stat_tracker.team_name(highest_scoring_home_team)
    end

    def lowest_scoring_visitors
        @stat_tracker.team_name(lowest_scoring_visitor)
    end

    def lowest_scoring_home_team
        @stat_tracker.team_name(lowest_scoring_home_team)
    end

#puts'--------------------Season Statistics--------------------'

    def winningest_coach
        @stat_tracker.team_name(winningest_coach)
    end

    def worst_coach
        @stat_tracker.team_name(worst_coach)
    end

    def most_accurate_team
        @stat_tracker.team_name(most_accurate_team)
    end

    def least_accurate_team
        @stat_tracker.team_name(least_accurate_team)
    end

    def most_tackles
        @stat_tracker.team_name(most_tackles)
    end

    def fewest_tackles
        @stat_tracker.team_name(fewest_tackles)
    end
    
#puts'--------------------Team Statistics--------------------'

    def team_info
        @stat_tracker.team_name(team_info)
    end

    def best_season
        @stat_tracker.team_name(best_season)
    end

    def worst_season
        @stat_tracker.team_name(worst_season)
    end

    def average_win_percentage
        @stat_tracker.team_name(average_win_percentage)
    end

    def most_goals_scored
        @stat_tracker.team_name(most_goals_scored)
    end

    def fewest_goals_scored
        @stat_tracker.team_name(fewest_goals_scored)
    end

    def favorite_opponent
        @stat_tracker.team_name(favorite_opponent)
    end

    def rival
        @stat_tracker.team_name(rival)
    end

    def biggest_team_blowout
        @stat_tracker.team_name(biggest_team_blowout)
    end

    def worst_loss
        @stat_tracker.team_name(worst_loss)
    end

    def head_to_head
        @stat_tracker.team_name(head_to_head)
    end

    def seasonal_summary
        @stat_tracker.team_name(seasonal_summary)
    end

