class CreateTypeRacers < ActiveRecord::Migration[5.1]
  def change
    create_table :type_racers do |t|

      t.timestamps
    end
  end
end
