class TeamStatistics
  attr_reader :teams,
              :stat_tracker,
              :games,
              :game_teams

  attr_accessor :team_info_hash

  def initialize(teams,games, game_teams, stat_tracker)
      @teams = teams
      @games = games
      @game_teams = game_teams
      @stat_tracker = stat_tracker
      @team_info_hash = {}
  end
  
  def team_name(team_id)
    @teams.find { |team| team.team_id == team_id }.team_name
  end

  def count_of_teams
      @teams.size
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
      #if the away team is the selected team, get the loss margin and if 
      #it is the worst one so far, put it as the value of max_loss, until all 
      #examples have been looked at

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
end