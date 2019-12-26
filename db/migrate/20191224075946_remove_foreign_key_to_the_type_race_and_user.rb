class RemoveForeignKeyToTheTypeRaceAndUser < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :type_race_stats, :type_races
    remove_foreign_key :type_race_stats, :users
  end
end
