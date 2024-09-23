require_relative 'stat_tracker'
require 'simplecov'
SimpleCov.start

RSpec.describe StatTracker do
  let(:locations) do
    {
      games: './data/games_dummy.csv',
      teams: './data/teams_dummy.csv',
      game_teams: './data/game_teams_dummy.csv'
    }
  end

  let(:stat_tracker) { StatTracker.from_csv(locations) }

  describe '#initialize' do
    it 'creates game, team, and game_team objects' do
      expect(stat_tracker.games).to all(be_a(Game))
      expect(stat_tracker.teams).to all(be_a(Team))
      expect(stat_tracker.game_teams).to all(be_a(GameTeam))
    end
  end

  describe 'league statistics' do
    it 'can count the number of teams' do
      expect(stat_tracker.count_of_teams).to eq(32)
    end

    it 'can find the best offense' do
      expect(stat_tracker.best_offense).to eq("FC Dallas")
    end

    it 'can find the worst offense' do
      expect(stat_tracker.worst_offense).to eq("Seattle Sounders FC")
    end

    it 'can find the highest scoring visitor' do
      expect(stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end

    it 'can find the highest scoring home team' do
      expect(stat_tracker.highest_scoring_home_team).to eq("New York City FC")
    end

    it 'can find the lowest scoring visitor' do
      expect(stat_tracker.lowest_scoring_visitor).to eq("Seattle Sounders FC")
    end

    it 'can find the lowest scoring home team' do
      expect(stat_tracker.lowest_scoring_home_team).to eq("Portland Timbers")
    end
  end

  describe 'team statistics' do
    it 'can return team info' do
      expected = {
        team_id: "1",
        franchise_id: "23",
        team_name: "Atlanta United",
        abbreviation: "ATL",
        link: "/api/v1/teams/1"
      }
      expect(stat_tracker.team_info('1')).to eq(expected)
    end

    it 'can find the favorite opponent of a team' do
      expect(stat_tracker.favorite_opponent("5")).to eq("Seattle Sounders FC")
    end

    it 'can find the rival of a team' do
      expect(stat_tracker.rival('6')).to eq("Houston Dynamo")
    end

    it 'can find the most goals scored by a team' do
      expect(stat_tracker.most_goals_scored("5")).to eq(4)
    end

    it 'can find the fewest goals scored by a team' do
      expect(stat_tracker.fewest_goals_scored("5")).to eq(0)
    end

    it 'can find the worst loss for a team' do
      expect(stat_tracker.worst_loss('3')).to eq(3)
    end

    it 'can find the biggest team blowout' do
      expect(stat_tracker.biggest_team_blowout('26')).to eq(2)
    end

    it 'can identify the worst season for a team' do
      expect(stat_tracker.worst_season('15')).to eq('20152016')
    end

    it 'can identify the best season for a team' do
      expect(stat_tracker.best_season('15')).to eq('20122013')
    end
  end

  describe 'season statistics' do
    it 'can find the winningest coach in a season' do
      expect(stat_tracker.winningest_coach('20122013')).to eq('Claude Julien')
    end

    it 'can find the worst coach in a season' do
      expect(stat_tracker.worst_coach('20122013')).to eq('John Tortorella')
    end

    it 'can find the most accurate team in a season' do
      expect(stat_tracker.most_accurate_team).to eq("Portland Timbers")
    end

    it 'can find the least accurate team in a season' do
      expect(stat_tracker.least_accurate_team).to eq("Seattle Sounders FC")
    end

    it 'can find the team with the most tackles in a season' do
      expect(stat_tracker.most_tackles("20122013")).to eq('Houston Dynamo')
    end

    it 'can find the team with the fewest tackles in a season' do
      expect(stat_tracker.fewest_tackles("20122013")).to eq('Portland Timbers')
    end
  end

  describe 'game statistics' do
    it 'gets percent of home wins' do      
      expect(stat_tracker.percentage_home_wins).to eq(0.55)
    end

    it 'gets percent of visitor wins' do      
      expect(stat_tracker.percentage_visitor_wins).to eq(0.42)
    end

    it 'highest total score' do      
      expect(stat_tracker.highest_total_score).to eq(7)
    end

    it 'lowest total score' do      
      expect(stat_tracker.lowest_total_score).to eq(1)
    end

    it 'average goals per game' do      
      expect(stat_tracker.average_goals_per_game).to eq(3.91)
    end
    
    it 'percentage of games that have resulted in a tie' do
      expect(stat_tracker.percentage_ties).to eq(0.03)
    end

    it "gets average win percentage" do
      expect(stat_tracker.average_win_percentage("6")).to eq 1.0
    end

    it 'average goals by season' do
      expected = {
        "20122013"=>3.86,
        "20132014"=>4.33,
        "20142015"=>3.75,
        "20152016"=>3.88,
        "20162017"=>4.75
      } 
      expect(stat_tracker.average_goals_by_season).to eq(expected)
    end

    it 'count of games by season' do
      expected = {
        "20122013"=>57,
        "20132014"=>6,
        "20142015"=>16,
        "20152016"=>16,
        "20162017"=>4
      }
      expect(stat_tracker.count_of_games_by_season).to eq(expected)
    end
  end
end