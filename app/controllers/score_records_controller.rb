class ScoreRecordsController < ApplicationController
  def create
    result = SaveScoreService.call(
      params[:leaderboard_id], params[:username], params[:score]
    )
    if result[:success]
      redirect_to result[:data][:leaderboard],
        notice: create_notice(result[:data][:position_change])
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

  private

  def create_notice(position_change)
    position_change.nil? ? "Score added" : "You gained #{position_change} positions!"
  end
end
