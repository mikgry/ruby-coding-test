class SaveScoreService < BaseService
  def initialize(leaderboard_id, username, score)
    @leaderboard = Leaderboard.find(leaderboard_id)
    @username = username
    @score = score
  end

  def call
    if entry_exists?
      update_entry
    else
      create_entry
    end
    leaderboard
  end

  private

  attr_accessor :leaderboard, :username, :score

  def entry_exists?
    leaderboard.entries.where(username: username).exists?
  end

  def update_entry
    entry = leaderboard.entries.find_by(username: username)
    LeaderboardEntry.update_counters(entry.id, score: score.to_i)
  end

  def create_entry
    leaderboard.entries.create!(username: username, score: score)
  rescue ActiveRecord::RecordNotUnique
    update_entry
  end
end
