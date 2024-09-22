require 'csv'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

class LeagueStatistics
  attr_reader :games,
              :teams,
              :game_teams,
              :stat_tracker

  def initialize(games, teams, game_teams, stat_tracker)
    @games = games
    @teams = teams
    @game_teams = game_teams
    @stat_tracker = stat_tracker
  end

  def count_of_teams
    @game_teams.map(&:team_id).uniq.count
  end

  def best_offense
    team_id = team_avg_goals.max_by { |team_id, avg_goals| avg_goals}[0]
    @stat_tracker.team_name(team_id)
  end

  def worst_offense
     team_id = team_avg_goals.min_by { |team_id, avg_goals| avg_goals}[0]
    @stat_tracker.team_name(team_id)
  end

  def highest_scoring_visitor
    team_id = team_avg_goals_as_visitor.max_by { |team_id, avg_goals| avg_goals }[0]
    @stat_tracker.team_name(team_id)
  end

  def lowest_scoring_visitor
    team_id = team_avg_goals_as_visitor.min_by { |team_id, avg_goals| avg_goals }[0]
    @stat_tracker.team_name(team_id)
  end
  
  def team_avg_goals
    total_goals_by_team = Hash.new(0)
    total_games_by_team = Hash.new(0)

    @game_teams.each do |game_team|
      team_id = game_team.team_id
      total_goals_by_team[team_id] += game_team.goals.to_i
      total_games_by_team[team_id] += 1
    end

    total_goals_by_team.transform_values do |total_goals|
      total_games = total_games_by_team[total_goals_by_team.key(total_goals)]
      total_games > 0 ? total_goals.to_f / total_games : 0
    end
  end

  def team_avg_goals_as_visitor
    total_goals_by_team = Hash.new(0)
    total_games_by_team = Hash.new(0)

    @games.each do |game|
      total_goals_by_team[game.away_team_id] += game.away_goals.to_i
      total_games_by_team[game.away_team_id] += 1
    end

    total_goals_by_team.transform_values do |total_goals|
      games_played = total_games_by_team[total_goals_by_team.key(total_goals)]
      games_played > 0 ? total_goals.to_f / games_played : 0
    end
  end

  def home_games 
    @game_teams.find_all { |game_team| game_team.HoA == 'home'} #select is finding all the teams (game_teams) that HoA is home. So it goes through the array and any row where HoA = home is returned
  end
      
  def team_home_games(team_id)   
    home_games.find_all { |game_team| game_team.team_id == team_id } #uses home_games to find all a specific teams home games
  end

  def total_home_games(team_id)
    team_home_games(team_id).count #returning the count of a specific teams home games
  end

  def total_home_score(team_id)
    team_home_games(team_id).sum { |game_team| game_team.goals.to_f } #calls the team_home_games method (which tells you how many home games teams_id has) it sums up all the games.goals and converts them to a float
  end

  def highest_scoring_home_team_id
    home_games.max_by do |game_team| 
      id = game_team.team_id
      total_home_score(id) / total_home_games(id)
    end.team_id
  end

  def highest_scoring_home_team
    @stat_tracker.team_name(highest_scoring_home_team_id)
  end
  
  def lowest_scoring_home_team_id
     home_games.min_by do |game_team| 
      id = game_team.team_id
      total_home_score(id) / total_home_games(id)
    end.team_id
  end

  def lowest_scoring_home_team
    @stat_tracker.team_name(lowest_scoring_home_team_id)
  end
end