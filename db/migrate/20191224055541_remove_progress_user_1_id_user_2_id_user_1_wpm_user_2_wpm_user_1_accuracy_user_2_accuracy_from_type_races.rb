class RemoveProgressUser1IdUser2IdUser1WpmUser2WpmUser1AccuracyUser2AccuracyFromTypeRaces < ActiveRecord::Migration[5.1]
  def change
    remove_column :type_races, :progress, :text
    remove_column :type_races, :user_1_id, :integer
    remove_column :type_races, :user_2_id, :integer
    remove_column :type_races, :user_1_wpm, :integer
    remove_column :type_races, :user_2_wpm, :integer
    remove_column :type_races, :user_1_accuracy, :integer
    remove_column :type_races, :user_2_accuracy, :integer
  end
end
