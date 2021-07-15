desc "To keep consistent data, we need to create initial leaderboard_entry_score for each leaderboard_entry"

task initialize_leaderboard_entry_score: :environment do
  LeaderboardEntry.where.not(score: nil).find_each do |leaderboard_entry|
    leaderboard_entry.score_records.create!(score: leaderboard_entry.score)
  end
end
