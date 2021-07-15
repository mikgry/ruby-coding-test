require 'rails_helper'

RSpec.describe ScoreRecordsController, type: :controller do
  let(:valid_attributes) {
    { name: 'test' }
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
end
