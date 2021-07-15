class ScoreRecord < ApplicationRecord
  belongs_to :entry, class_name: 'LeaderboardEntry', foreign_key: :leaderboard_entry_id

  delegate :username, to: :entry
end
