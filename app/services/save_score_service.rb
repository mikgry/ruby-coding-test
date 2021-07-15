class SaveScoreService < BaseService
  def initialize(leaderboard_id, username, score)
    @leaderboard = Leaderboard.find(leaderboard_id)
    @username = username
    @score = score
  end

  def call
    position_change = if entry_exists?
      update_entry
    else
      create_entry
    end
    { success: true, data: { leaderboard: leaderboard, position_change: position_change } }
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
    old_position = position_query(entry.id).load
    LeaderboardEntry.transaction do
      LeaderboardEntry.update_counters(entry.id, score: score.to_i)
      create_score_record(entry)
    end
    old_position - position_query(entry.id).load
  end

  def position_query(entry_id)
    @position_query ||= GetRankQuery.new(leaderboard.id, entry_id)
  end

  def create_entry
    LeaderboardEntry.transaction do
      entry = leaderboard.entries.create!(username: username, score: score)
      create_score_record(entry)
    end
    nil
  rescue ActiveRecord::RecordNotUnique
    update_entry
  end

  def create_score_record(entry)
    entry.score_records.create!(score: score)
  end
end
