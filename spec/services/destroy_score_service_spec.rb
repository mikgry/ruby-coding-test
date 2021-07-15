require "rails_helper"

describe DestroyScoreService do
  let(:leaderboard_params) {
    { name: 'test' }
  }

  let(:entry_params) {
    { username: 'lala', score: 3 }
  }
  let!(:leaderboard) { Leaderboard.create!(leaderboard_params) }
  let!(:entry) { leaderboard.entries.create!(entry_params) }
  let!(:score_record_1) { entry.score_records.create!(score: 1) }
  let!(:score_record_2) { entry.score_records.create!(score: 2) }

  it "updates the entry" do
    expect {
      described_class.call(leaderboard.id, score_record_2.id)
    }.to change { entry.reload.score }.by(-2)
  end

  it "deletes the score_record" do
    expect {
      described_class.call(leaderboard.id, score_record_2.id)
    }.to change(ScoreRecord, :count).by(-1)
  end
end
