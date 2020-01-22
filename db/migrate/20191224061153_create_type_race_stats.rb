class CreateTypeRaceStats < ActiveRecord::Migration[5.1]
  def change
    create_table :type_race_stats do |t|
      t.integer :type_race_id
      t.integer :user_id
      t.integer :wpm
      t.text :progress
      t.integer :accuracy

      t.timestamps
    end
  end
end
