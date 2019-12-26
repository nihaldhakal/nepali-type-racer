class DropTypeRacesUsers < ActiveRecord::Migration[5.1]
  def change
    drop_join_table :type_races, :users
  end
end
