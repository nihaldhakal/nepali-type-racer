class AddUserIdProgressAccuracyWpmToTypeRaces < ActiveRecord::Migration[5.1]
  def up
    add_column :type_races, :user_1_id, :integer
    add_column :type_races, :user_2_id, :integer
    add_column :type_races, :user_1_wpm, :integer
    add_column :type_races, :user_2_wpm, :integer
    add_column :type_races, :user_1_accuracy,:integer
    add_column :type_races, :user_2_accuracy, :integer
    add_column :type_races, :user_1_progress, :text
    add_column :type_races, :user_2_progress, :text
  end

  def down

  end
end
