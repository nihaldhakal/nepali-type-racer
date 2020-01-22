class AddForeignKeyToTheTypeRacesAndUsers < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :type_races, :type_race_stats
    add_foreign_key :users, :type_race_stats
  end
end
