class RenameTypeRacersToTypeRaces < ActiveRecord::Migration[5.1]
  def change
    rename_table :type_racers, :type_races
  end
end
