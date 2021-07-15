class GetRankQuery
  def initialize(leaderboard_id, leaderboard_entry_id)
    @safe_leaderboard_id = ActiveRecord::Base.connection.quote(leaderboard_id)
    @safe_leaderboard_entry_id = ActiveRecord::Base.connection.quote(leaderboard_entry_id)
  end

  def load
    ActiveRecord::Base.connection.execute(prepare_query).to_a.first["rank"]
  end

  private

  attr_accessor :safe_leaderboard_id, :safe_leaderboard_entry_id

  def prepare_query
    <<~SQL
      SELECT rank FROM ( SELECT id, ROW_NUMBER() OVER (ORDER BY score DESC) AS rank
        FROM leaderboard_entries WHERE leaderboard_id = #{safe_leaderboard_id}
      ) subquery WHERE subquery.id = #{safe_leaderboard_entry_id}
    SQL
  end
end
