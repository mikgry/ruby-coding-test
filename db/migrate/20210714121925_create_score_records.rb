class CreateScoreRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :score_records do |t|
      t.references :leaderboard_entry, foreign_key: true
      t.integer :score, null: false

      t.timestamps
    end
  end
end
