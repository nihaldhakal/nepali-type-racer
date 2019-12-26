class AddProgressUser1IdUser2IdUser1WpmUser2WpmUser1AccuracyUser2AccuracyToTypeRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :type_races, :progress, :text
    add_column :type_races, :user_1_id, :integer
    add_column :type_races, :user_2_id, :integer
    add_column :type_races, :user_1_wpm, :integer
    add_column :type_races, :user_2_wpm, :integer
    add_column :type_races, :user_1_accuracy, :integer
    add_column :type_races, :user_2_accuracy, :integer
  end
end
