class AddUniqueIndexToLeaderboardEntriesOnUsernameAndLeaderboardId < ActiveRecord::Migration[5.1]
  def change
    add_index :leaderboard_entries, [:leaderboard_id, :username], unique: true
  end
end
