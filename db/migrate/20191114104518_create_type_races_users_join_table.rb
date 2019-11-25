class CreateTypeRacesUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :type_races, :users
  end
end
