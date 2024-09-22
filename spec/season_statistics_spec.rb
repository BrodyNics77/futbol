require './spec/spec_helper'

RSpec.describe SeasonStatistics do
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
    @season_stats = SeasonStatistics.new(@stat_tracker.games, @stat_tracker.teams, @stat_tracker.game_teams, @stat_tracker)
  end

  describe '#coach stats' do
    it 'knows the winningest coach' do     
      expect(@season_stats.winningest_coach(20122013)).to eq('Claude Julien')
    end

    it 'knows the worst coach' do     
      expect(@season_stats.worst_coach(20122013)).to eq('John Tortorella')
    end
  end

  describe '#accuracy stats' do
    it 'knows the most accurate team' do
      expect(@season_stats.most_accurate_team).to eq("New York City FC")
    end

    it 'knows the least accurate team' do
      expect(@season_stats.least_accurate_team).to eq('Houston Dynamo')
    end
  end

  describe '#tackle stats' do
    it 'knows the team with the most tackles' do
      expect(@season_stats.most_tackles("20122013")).to eq('Houston Dynamo')
    end

    it 'knows the team with the fewest tackles' do
      expect(@season_stats.fewest_tackles("20122013")).to eq('Portland Timbers')
    end
  end
end
