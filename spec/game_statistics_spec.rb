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
          expect(@game_stats.highest_total_score).to eq(7)
        end

        it 'knows the lowest total score' do
           expect(@game_stats.lowest_total_score).to eq(1)
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
           expect(@game_stats.count_of_games_by_season).to eq({season: 20122013, games: 1}, {season: 20162017, games: 4}, {season: 20142015, games: 3})
        end
    end

    describe '#calculates average goals' do
        it 'can average the goals scored per game by both teams in all seasons combined' do
        expect(@game_stats.average_goals_per_game).to eq(3.91)
        end

        it 'can average the goals scored per game by both teams in a single season' do
            expect(@game_stats.average_goals_by_season).to eq({season: 20122013, goals: 5}, {season: 20162017, goals: 4.75}, {season: 20142015, goals: 4.33})
        end
    end
end