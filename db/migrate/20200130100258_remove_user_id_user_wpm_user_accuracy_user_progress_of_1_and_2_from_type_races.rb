class RemoveUserIdUserWpmUserAccuracyUserProgressOf1And2FromTypeRaces < ActiveRecord::Migration[5.1]
  def up
    remove_column :type_races, :user_1_id
    remove_column :type_races, :user_2_id
    remove_column :type_races, :user_1_wpm
    remove_column :type_races, :user_2_wpm
    remove_column :type_races, :user_1_accuracy
    remove_column :type_races, :user_2_accuracy
    remove_column :type_races, :user_1_progress
    remove_column :type_races, :user_2_progress
  end

  def down

  end
end
