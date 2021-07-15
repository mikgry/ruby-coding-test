class LeaderboardEntry < ApplicationRecord
  belongs_to :leaderboard
  has_many :score_records, inverse_of: :entry, dependent: :destroy
end
