class Leaderboard < ApplicationRecord
  has_many :entries, class_name: 'LeaderboardEntry'
  has_many :score_records, through: :entries
end
