require 'rails_helper'

RSpec.describe ScoreRecordsController, type: :controller do
  let(:valid_attributes) {
    { name: 'test' }
  }

  let(:entry_params) {
    { username: "John", score: 2 }
  }

  describe 'POST #create' do
    it 'adds score' do
      leaderboard = Leaderboard.create! valid_attributes
      params = { leaderboard_id: leaderboard.id, username: 'lala', score: 1 }

      expect(SaveScoreService).to receive(:call).with(
        params[:leaderboard_id].to_s, params[:username], params[:score].to_s
      ).and_return(leaderboard)
      post :create, params: params
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested score_record" do
      leaderboard = Leaderboard.create! valid_attributes
      entry = leaderboard.entries.create(entry_params)
      score = entry.score_records.create(score: entry.score)
      expect {
        delete :destroy, params: {leaderboard_id: leaderboard.id, id: score.id}
      }.to change(ScoreRecord, :count).by(-1)
    end

    it "redirects to the leaderboard show view" do
      leaderboard = Leaderboard.create! valid_attributes
      entry = leaderboard.entries.create(entry_params)
      score = entry.score_records.create(score: entry.score)
      delete :destroy, params: {leaderboard_id: leaderboard.id, id: score.id}
      expect(response).to redirect_to(leaderboard_url(leaderboard))
    end
  end
end
