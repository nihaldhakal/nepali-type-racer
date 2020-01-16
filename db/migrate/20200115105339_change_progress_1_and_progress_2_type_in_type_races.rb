class ChangeProgress1AndProgress2TypeInTypeRaces < ActiveRecord::Migration[5.1]
  def up
    change_column :type_races, :user_1_progress,:text
    change_column :type_races, :user_2_progress,:text
  end

  def down
    change_column :type_races, :user_1_progress,:string
    change_column :type_races, :user_2_progress,:string
  end

end
