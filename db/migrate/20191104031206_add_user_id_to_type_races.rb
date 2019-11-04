class AddUserIdToTypeRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :type_races, :user_id, :integer
  end
end
