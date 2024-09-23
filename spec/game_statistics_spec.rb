require './spec/spec_helper'

RSpec.describe GameStatistics do
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
        @game_stats = GameStatistics.new(@stat_tracker.games, @stat_tracker.game_teams, @stat_tracker)
    end

    describe '#total score stats' do
        it 'knows the highest total score' do
          expect(@game_stats.highest_total_score).to eq(11)
        end

        it 'knows the lowest total score' do
          expect(@game_stats.lowest_total_score).to eq(7)          
        end
    end

    describe '#win, loss, and tie percentages' do
        it 'knows the percentage of home wins' do
          expect(@game_stats.percentage_home_wins).to eq(0.50)
        end

        it 'knows the percentage of visitor wins' do
          expect(@game_stats.percentage_visitor_wins).to eq(0.50)          
        end

        it 'knows the percentage of ties' do
          expect(@game_stats.percentage_ties).to eq(0.0)
        end
    end

    describe '#knows the number of games in a season' do
        it 'counts the games in a season' do
          expected = {"20122013"=>57, "20162017"=>4, "20142015"=>16, "20152016"=>16, "20132014"=>6}
          expect(@game_stats.count_of_games_by_season).to eq(expected)
        it 'counts the games in a season' do
            expected = {"20122013"=>57, "20162017"=>4, "20142015"=>16, "20152016"=>16, "20132014"=>6}
        expect(@game_stats.count_of_games_by_season).to eq(expected)
        end
    end

    describe '#calculates average goals' do
        it 'can average the goals scored per game by both teams in all seasons combined' do
          expect(@game_stats.average_goals_per_game).to eq(3.91)
        end
    

        it 'can average the goals scored per season' do
           expected = {"20122013"=>3.86, "20162017"=>4.75, "20142015"=>3.75, "20152016"=>3.88, "20132014"=>4.33}
           expect(@game_stats.average_goals_by_season).to eq(expected)
        end

        it 'can total the goals per season' do
           expected = {"20122013"=>220, "20162017"=>19, "20142015"=>60, "20152016"=>62, "20132014"=>26}
           expect(@game_stats.total_goals_by_season).to eq(expected)
        end
    end
end