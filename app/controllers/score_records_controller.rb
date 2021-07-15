class ScoreRecordsController < ApplicationController
  def create
    result = SaveScoreService.call(
      params[:leaderboard_id], params[:username], params[:score]
    )
    if result[:success]
      redirect_to result[:data], notice: 'Score added'
    else
      redirect_to Leaderboard.find(params[:leaderboard_id]),
        alert: "Score isn't added"
    end
  end

  def destroy
    DestroyScoreService.call(params[:leaderboard_id], params[:id])
    redirect_to Leaderboard.find(params[:leaderboard_id]),
      notice: 'ScoreRecord was successfully destroyed.'
  end
end
