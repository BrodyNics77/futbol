require 'csv'
require './lib/game'
require './lib/team'
require './lib/game_team'

class StatTracker
  attr_reader :games, :teams, :game_teams

  def self.from_csv(locations)
    new(locations)
  end

  def initialize(locations)
    @games = create_objects_of_type(locations[:games], Game, :game_id)
    @teams = create_objects_of_type(locations[:teams], Team, :team_id)
    @game_teams = create_objects_of_type(locations[:game_teams], GameTeam, :game_id)
  end

  def team_name(team_id)
    @teams.find { |team| team.team_id == team_id }&.team_name
  end

  def count_of_teams
    @teams.size
  end

  def best_offense
    team_id = team_avg_goals.max_by { |team_id, avg_goals| avg_goals }[0]
    team_name(team_id)
  end

  def worst_offense
    team_id = team_avg_goals.min_by { |team_id, avg_goals| avg_goals }[0]
    team_name(team_id)
  end

  def highest_scoring_visitor
    team_id = team_avg_goals_as_visitor.max_by { |team_id, avg_goals| avg_goals }[0]
    team_name(team_id)
  end

  def lowest_scoring_visitor
    team_id = team_avg_goals_as_visitor.min_by { |team_id, avg_goals| avg_goals }[0]
    team_name(team_id)
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

  def highest_scoring_home_team
    team_id = team_avg_goals_as_home.max_by { |team_id, avg_goals| avg_goals }[0]
    team_name(team_id)
  end
  
  def lowest_scoring_home_team
    team_id = team_avg_goals_as_home.min_by { |team_id, avg_goals| avg_goals }[0]
    team_name(team_id)
  end
  
  def team_avg_goals_as_home
    total_goals_by_team = Hash.new(0)
    total_games_by_team = Hash.new(0)
  
    @games.each do |game|
      total_goals_by_team[game.home_team_id] += game.home_goals.to_i
      total_games_by_team[game.home_team_id] += 1
    end
  
    total_goals_by_team.transform_values do |total_goals|
      games_played = total_games_by_team[total_goals_by_team.key(total_goals)]
      games_played > 0 ? total_goals.to_f / games_played : 0
    end
  end

  def most_goals_scored(team_id)
    goals = 0
    @games.each do |game|
        if game.away_team_id == team_id && game.away_goals.to_i > goals
            goals = game.away_goals.to_i
        end
        
        if game.home_team_id == team_id && game.home_goals.to_i > goals
            goals = game.home_goals.to_i
        end
    end
    goals
  end

  def fewest_goals_scored(team_id)
      goals = 99
      @games.each do |game|
          if game.away_team_id == team_id && game.away_goals.to_i < goals
              goals = game.away_goals.to_i
          end
          
          if game.home_team_id == team_id && game.home_goals.to_i < goals
              goals = game.home_goals.to_i
          end
      end
      goals
  end

  def head_to_head(team_id)
      results = Hash.new { |hash, key| hash[key] = { wins: 0, losses: 0, win_percentage: 0.0} }

      @games.each do |game|
        if game.away_team_id == team_id
          opp_team_id = game.home_team_id
          if game.away_goals.to_i > game.home_goals.to_i
              results[opp_team_id][:wins] +=1
          else
              results[opp_team_id][:losses] += 1
          end            
        elsif game.home_team_id == team_id
          opp_team_id = game.away_team_id
          if game.home_goals.to_i > game.away_goals.to_i
          results[opp_team_id][:wins] += 1
          else
              results[opp_team_id][:losses] += 1
          end
        end
      end        

      results.each do |opp_team_id, record|
          total_games = record[:wins] + record[:losses]
          record[:win_percentage] = total_games > 0 ? (record[:wins].to_f / total_games).round(2) : 0.0                        
      end 

      results.transform_keys! { |id| team_name(id) }
      results
  end

  def rival(team_id)
      head_to_head_results = head_to_head(team_id)
      lowest_win_percentage = head_to_head_results.values.min_by { |record| record[:win_percentage] }
      rival = head_to_head_results.key(lowest_win_percentage)
      rival
  end  

  def favorite_opponent(team_id)
    head_to_head_results = head_to_head(team_id)    
    highest_win_percentage = head_to_head_results.values.max_by { |record| record[:win_percentage]}
    favorite =  head_to_head_results.key(highest_win_percentage)
    favorite     
  end 

  def worst_loss(team_id)
      max_loss = 0
    @games.each do |game|
      if game.away_team_id == team_id
        loss_margin = game.home_goals.to_i - game.away_goals.to_i
        max_loss = loss_margin if loss_margin > max_loss
      end      

      if game.home_team_id == team_id
        loss_margin = game.away_goals.to_i - game.home_goals.to_i
        max_loss = loss_margin if loss_margin > max_loss
      end
    end
      max_loss
  end
  
  def biggest_team_blowout(team_id)
      max_blowout = 0
    @games.each do |game|
      if game.away_team_id == team_id
        blowout_margin = game.away_goals.to_i - game.home_goals.to_i
        max_blowout = blowout_margin if blowout_margin > max_blowout
      end

      if game.home_team_id == team_id
        blowout_margin = game.home_goals.to_i - game.away_goals.to_i
        max_blowout = blowout_margin if blowout_margin > max_blowout
      end
    end
      max_blowout
  end

  def team_info(team_id)
          @teams.each do |team| 
          if team_id == team.team_id
              @team_info_hash.update({team_id: team.team_id, 
                                  franchiseId: team.franchiseId,
                                  team_name: team.team_name,
                                  abbreviation: team.abbreviation,
                                  link: team.link})
          end
      end
      @team_info_hash
  end                             

  def seasons_wins(team_id)
    wins = 0
    @game_teams.each do |game|
      if team_id == game.team_id.to_s && game.result == 'WIN'
        wins += 1
      end
    end
    wins
  end

  def season_losses(team_id)
    losses = 0
    @game_teams.each do |game|
      if team_id == game.team_id.to_s && game.result == 'LOSS'
        losses += 1
      end
    end
    losses
  end

  def season_total_games(team_id)
    require 'pry'; binding.pry
    total_games = 0
    @game_teams.each do |game|
      if team_id == game.team_id.to_s && game.result == 'TIE'
      total_games  += 1 + season_losses + seasons_wins
      end
    end
    total_games
  end


  def worst_season(team_id)
    season_stats = Hash.new {|hash,key| hash[key] = {games_played: 0, wins: 0}}
    @games.each do |game|
      next unless game.away_team_id == team_id || game.home_team_id == team_id
      season = game.season
      season_stats[season][:games_played]+= 1
      if (game.away_team_id == team_id && game.away_goals > game.home_goals || 
        (game.home_team_id == team_id && game.home_goals > game.away_goals))
        season_stats[season][:wins]+= 1
      end
    end
    worst_season = season_stats.min_by do |_, stats|
      stats[:wins].to_f / stats[:games_played]
    end
    worst_season[0]
  end

  def best_season(team_id)
    season_stats = Hash.new {|hash,key| hash[key] = {games_played: 0, wins: 0}}
    @games.each do |game|
      next unless game.away_team_id == team_id || game.home_team_id == team_id
      season = game.season
      season_stats[season][:games_played]+= 1
      if (game.away_team_id == team_id && game.away_goals > game.home_goals || 
        (game.home_team_id == team_id && game.home_goals > game.away_goals))
        season_stats[season][:wins]+= 1
      end
    end
    best_season = season_stats.max_by do |_, stats|
      stats[:wins].to_f / stats[:games_played]
    end
    best_season[0]
  end

  def team_info(team_id)
    team_info_hash = {}  
    idteam = @teams.find { |team| team.team_id == team_id }
      
      team_info_hash = {  
        team_id: idteam.team_id, 
        franchise_id: idteam.franchise_id,
        team_name: idteam.team_name,
        abbreviation: idteam.abbreviation,
        link: idteam.link 
        }
  
    team_info_hash
  end
  def most_accurate_team
    goals = Hash.new(0)
    shots = Hash.new(0)
  
    @game_teams.each do |game_team|
      team_id = game_team.team_id
      goals[team_id] += game_team.goals.to_i
      shots[team_id] += game_team.shots.to_i
    end
  
    most_accurate_team_id = goals.keys.max_by do |team_id|
      accuracy(goals[team_id], shots[team_id]) 
    end
  
    team_name(most_accurate_team_id)
  end
  
  def accuracy(goals, shots)
    (goals.to_f / shots) * 100
  end
  
  def least_accurate_team
    goals = Hash.new(0)
    shots = Hash.new(0)
  
    @game_teams.each do |game_team| 
      team_id = game_team.team_id
      goals[team_id] += game_team.goals.to_i
      shots[team_id] += game_team.shots.to_i
    end
  
    least_accurate_team_id = goals.keys.min_by do |team_id|
      accuracy(goals[team_id], shots[team_id])
    end
  
    team_name(least_accurate_team_id)
  end
  
  def winningest_coach(season)    
    coach_rating = coach_win_percentages(season)    
    coach_rating.max_by { |stats| stats[:win_percentage] }[:coach]
  end
  
  def worst_coach(season)    
    coach_rating = coach_win_percentages(season)      
    coach_rating.min_by { |stats| stats[:win_percentage] }[:coach]
  end

  def coach_win_percentages(season)    
    total_games = Hash.new(0)
    wins= Hash.new(0)

    @game_teams.each do |game_team|
      game = @games.find { |g| g.game_id == game_team.game_id }      
      next unless game.season == season.to_s    

      coach = game_team.head_coach
      total_games[coach] += 1
      wins[coach] += 1 if game_team.result == "WIN"
    end
    

    total_games.map do |coach, games|
      win_percentage = win_percentage(wins[coach], games)
      { coach: coach, win_percentage: win_percentage}
    end
  end

  def fewest_tackles(season)
    tackles_teams = Hash.new(0)
    @games.each do |game|
      if game.season == season
        @game_teams.each do |game_team|
          if game.game_id == game_team.game_id
            team_id = game_team.team_id
            tackles_teams[team_id] += game_team.tackles.to_i
          end
        end
      end
    end
    team_fewest_tackles = tackles_teams.min_by { |team, tackles| tackles }[0]
    team_name(team_fewest_tackles)
  end
  
  def most_tackles(season)
    tackles_teams = Hash.new(0)
    @games.each do |game|
      if game.season == season
        @game_teams.each do |game_team|
          if game.game_id == game_team.game_id
            team_id = game_team.team_id
            tackles_teams[team_id] += game_team.tackles.to_i
          end
        end
      end
    end
    team_most_tackles = tackles_teams.max_by { |team, tackles| tackles }[0]
    team_name(team_most_tackles)
  end

  def highest_total_score
    @games.map { |game| game.home_goals.to_i + game.away_goals.to_i }.max
  end

  def lowest_total_score
    @games.map { |game| game.home_goals.to_i + game.away_goals.to_i }.min
  end
  
  def percentage_home_wins
    home_wins = @games.count { |game| game.home_goals > game.away_goals }
    (home_wins.to_f / @games.length).round(2)
  end
  
  def percentage_visitor_wins
    visitor_wins = @games.count { |game| game.away_goals > game.home_goals }
    (visitor_wins.to_f / @games.length).round(2)
  end
  
  def percentage_ties
    ties = @games.count { |game| game.home_goals == game.away_goals }
    (ties.to_f / @games.length).round(2)
  end
  
  def count_of_games_by_season
    @games.group_by { |game| game.season }.transform_values(&:count)
  end 
  
  def average_goals_per_game
    total_goals = @games.sum do |game|
      game.home_goals.to_i + game.away_goals.to_i
    end
    average_goals = total_goals.to_f / @games.size
    average_goals.round(2)
  end
  
  def average_goals_by_season
    games_by_season = @games.group_by(&:season)
    games_by_season.transform_values do |games|
      total_goals = games.sum { |game| game.away_goals.to_i + game.home_goals.to_i }
      (total_goals.to_f / games.size).round(2)
    end
  end

  def average_win_percentage(team_id)
    team_games = @games.select { |game| game.away_team_id == team_id || game.home_team_id == team_id }
    return 0.0 if team_games.empty?
  
    wins = team_games.count do |game|
      (game.home_team_id == team_id && game.home_goals > game.away_goals) ||
      (game.away_team_id == team_id && game.away_goals > game.home_goals)
    end
  
    (wins.to_f / team_games.length).round(2)
  end
  
  def win_percentage(wins, total)
    return 0 if total == 0
    (wins.to_f / total) * 100
  end
  
  def team_name(team_id)
    team = @teams.find { |team| team.team_id == team_id }
    team.team_name
  end  
  
  def create_objects_of_type(path, object_type, unique_attribute)
    objects = CSV.read(path, headers: true).map { |row| object_type.new(row) }
    objects.uniq(&unique_attribute)
  end  
end