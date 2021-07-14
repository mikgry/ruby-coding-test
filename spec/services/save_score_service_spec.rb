require "rails_helper"

describe SaveScoreService do
  let(:leaderboard_params) {
    { name: 'test' }
  }

  let(:entry_params) {
    { username: 'lala', score: 1 }
  }
  let!(:leaderboard) { Leaderboard.create!(leaderboard_params) }

  it "creates new entry" do
    expect {
      described_class.call(leaderboard.id, entry_params[:username], entry_params[:score])
    }.to change(LeaderboardEntry, :count).by(1)
  end

  context "entry already exists" do
    let!(:entry) { leaderboard.entries.create!(entry_params) }

    it "updates the entry" do
      expect {
        described_class.call(leaderboard.id, entry_params[:username], entry_params[:score])
      }.to change { entry.reload.score }.by(entry_params[:score])
    end

    it "does not create a new entry" do
      expect {
        described_class.call(leaderboard.id, entry_params[:username], entry_params[:score])
      }.to_not change(LeaderboardEntry, :count)
    end
  end

  context "entry is created during execution" do
    let!(:entry) { leaderboard.entries.create!(entry_params) }

    before do
      allow_any_instance_of(described_class).to receive(:entry_exists?).and_return(false)
    end

    it "updates the entry" do
      expect {
        described_class.call(leaderboard.id, entry_params[:username], entry_params[:score])
      }.to change { entry.reload.score }.by(entry_params[:score])
    end

    it "does not create a new entry" do
      expect {
        described_class.call(leaderboard.id, entry_params[:username], entry_params[:score])
      }.to_not change(LeaderboardEntry, :count)
    end
  end
end
