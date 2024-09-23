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

    def average_goals_per_game
        @stat_tracker.team_name(average_goals_per_game_id)
    end

    def average_goals_by_season
        @stat_tracker.name(average_goals_by_season_id)
    end
    


    #puts'--------------------League Statistics--------------------'

    def count_of_teams
        @stat_tracker.name(count_of_teams_id)
      end
    
    def best_offense
        @stat_tracker.name(best_offense_id)
    end

    def worst_offense
        @stat_tracker.team_name(worst_offense_id)
    end

    def highest_scoring_visitor
        @stat_tracker.team_name(highest_scoring_visitor_id)
    end

    def highest_scoring_home_team
        @stat_tracker.team_name(highest_scoring_home_team_id)
    end

    def lowest_scoring_visitors
        @stat_tracker.team_name(lowest_scoring_visitor_id)
    end

    def lowest_scoring_home_team
        @stat_tracker.team_name(lowest_scoring_home_team_id)
    end



#puts'--------------------Season Statistics--------------------'


    
    def highest_scoring_home_team
        @stat_tracker.team_name(highest_scoring_home_team_id)
      end
    
    def lowest_scoring_home_team
        @stat_tracker.team_name(lowest_scoring_home_team_id)
      end
    
end