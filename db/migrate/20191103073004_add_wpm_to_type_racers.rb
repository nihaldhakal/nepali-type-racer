class AddWpmToTypeRacers < ActiveRecord::Migration[5.1]
  def change
    add_column :type_races, :wpm, :integer
  end
end
