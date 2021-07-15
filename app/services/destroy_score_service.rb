class DestroyScoreService < BaseService
  def initialize(leaderboard_id, score_record_id)
    @score_record = Leaderboard.find(leaderboard_id).score_records.find(score_record_id)
  end

  def call
    LeaderboardEntry.transaction do
      update_entry
      destroy_score_record
    end
  end

  private

  attr_accessor :score_record

  def update_entry
    LeaderboardEntry.update_counters(
      score_record.leaderboard_entry_id, score: -score_record.score
    )
  end

  def destroy_score_record
    score_record.destroy!
  end
end
