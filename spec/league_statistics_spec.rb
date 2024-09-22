require 'spec_helper'

RSpec.describe LeagueStatistics do 
  before(:each) do 
    game_path = './data/games_dummy.csv'
    team_path = './data/teams_dummy.csv'
    game_teams_path = './data/game_teams_dummy.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
    @league_statistics = LeagueStatistics.new(@stat_tracker.games, @stat_tracker.teams, @stat_tracker.game_teams, @stat_tracker) 
  end
  
  describe 'count_of_teams' do
    it 'counts the number of teams' do      
      expect(@league_statistics.count_of_teams).to eq(13)
    end
  end

  describe 'best_offense' do
    it 'returns the team with the highest average number of goals per game' do
      expect(@league_statistics.best_offense).to eq('FC Dallas')
    end
  end

  describe 'worst_offense' do
    it 'returns the team with the lowest average number of goals per game' do
      expect(@league_statistics.worst_offense).to eq('Houston Dynamo')
    end
  end

  describe 'highest_scoring_visitor' do
    it 'returns the team with the highest average score when they are away' do
      expect(@league_statistics.highest_scoring_visitor).to eq('FC Dallas')
    end
  end

  describe 'highest_scoring_home_team' do
    it 'returns the team with the highest average score when they are home' do
      expect(@league_statistics.highest_scoring_home_team).to eq('New York City FC')
    end

    it 'can find all home games' do
      expect(@league_statistics.home_games.count).to eq 49
    end
    
    it 'can find a specific teams home games' do 
      expect(@league_statistics.team_home_games('6').count).to eq 5
    end
    
    it 'can count a teams total home games' do
      expect(@league_statistics.total_home_games('6')).to eq 5
    end

    it 'can total the team home score' do
      expect(@league_statistics.total_home_score('6')).to eq 12.0
    end
    
    it 'can detetermine highest scoring team' do
      expect(@league_statistics.highest_scoring_home_team_id).to eq('9')
    end
  end

  describe 'lowest_scoring_visitor' do
    it 'returns the team with the lowest average score when they are away' do
      expect(@league_statistics.lowest_scoring_visitor).to eq('Seattle Sounders FC')
    end
  end

  describe 'lowest_scoring_home_team' do
    it 'returns the team with the lowest average score when they are home' do
      expect(@league_statistics.lowest_scoring_home_team_id).to eq('30')
    end
  end
end