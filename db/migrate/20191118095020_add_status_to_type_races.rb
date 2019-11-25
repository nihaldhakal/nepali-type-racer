class AddStatusToTypeRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :type_races, :status, :integer, default: 0
  end
end
