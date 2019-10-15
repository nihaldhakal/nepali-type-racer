class DroptypeRacers < ActiveRecord::Migration[5.1]
  def change
    drop_table :type_racers
  end
end
