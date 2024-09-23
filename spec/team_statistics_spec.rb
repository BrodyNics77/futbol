require './spec/spec_helper'

RSpec.describe TeamStatistics do 
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
    @team_statistics = TeamStatistics.new(@stat_tracker.teams, @stat_tracker.games, @stat_tracker.game_teams, @stat_tracker)
  end
  
  describe 'goals scored' do
    it 'counts the highest number of goals score by a team in a single game' do
      expect(@team_statistics.most_goals_scored("5")).to eq(4)
    end

    it 'counts the fewest number of goals score by a team in a single game' do
      expect(@team_statistics.fewest_goals_scored("5")).to eq(0)
    end
   end

   describe 'worst season' do
     team_id  = '15'
     expected = '20152016'
     it 'can identify worst season' do
     expect(@team_statistics.worst_season(team_id)).to eq(expected)
     end
   end

   describe 'best season' do
     team_id  = '15'
     expected = '20122013'
     it 'can identify best season' do
     expect(@team_statistics.best_season(team_id)).to eq(expected)
     end
   end
  
   describe '#head to head' do
     it 'gives a win percentage against opponents' do        
     houston_record = @team_statistics.head_to_head('6')["Houston Dynamo"]
     expect(houston_record).to eq({wins: 5, losses: 0, win_percentage: 1.0})
     end
   end

   describe '#rival' do
     it 'returns opponent with highest win percentage against' do
     expect(@team_statistics.rival('6')).to eq("Houston Dynamo")
     end
   end

   describe '#favorite opponent' do
     it 'can return the opponent with the lowest win percentage'do
     expect(@team_statistics.favorite_opponent("5")).to eq("FC Dallas")
     end
   end

   describe 'best win worst loss' do
     it 'can find the worst loss for a team' do
     expect(@team_statistics.worst_loss('3')).to eq(3)
     end
     
     it 'can find the biggest team blowout for a team' do
     expect(@team_statistics.biggest_team_blowout('26')).to eq(2)
     end
   end

   describe 'team information' do
     it 'has team info' do
     expect(@team_statistics.team_info('3')).to be_a(Hash)
     end

     it 'has team info' do
     expect(@team_statistics.team_info('3')).to be_a(Hash)
     expect(@team_statistics.team_info('1')).to eq({:abbreviation=>"ATL", :franchise_id=>"23", :link=>"/api/v1/teams/1", :team_id=>"1", :team_name=>"Atlanta United"})
     end
   end 
end