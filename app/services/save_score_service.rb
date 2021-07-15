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
    { success: true, data: leaderboard }
  rescue ActiveRecord::RecordInvalid => exception
    { success: false, data: exception }
  end

  private

  attr_accessor :leaderboard, :username, :score

  def entry_exists?
    leaderboard.entries.where(username: username).exists?
  end

  def update_entry
    entry = leaderboard.entries.find_by(username: username)
    LeaderboardEntry.transaction do
      LeaderboardEntry.update_counters(entry.id, score: score.to_i)
      create_score_record(entry)
    end
  end

  def create_entry
    LeaderboardEntry.transaction do
      entry = leaderboard.entries.create!(username: username, score: score)
      create_score_record(entry)
    end
  rescue ActiveRecord::RecordNotUnique
    update_entry
  end

  def create_score_record(entry)
    entry.score_records.create!(score: score)
  end
end
