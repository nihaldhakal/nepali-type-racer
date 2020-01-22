class AddForeignKeyToTheTypeRaceAndUser < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :type_race_stats, :type_races
    add_foreign_key :type_race_stats, :users

  end
end
