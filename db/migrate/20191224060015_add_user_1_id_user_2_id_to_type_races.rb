class AddUser1IdUser2IdToTypeRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :type_races, :user_1_id, :integer
    add_column :type_races, :user_2_id, :integer
  end
end
