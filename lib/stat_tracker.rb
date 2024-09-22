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
end