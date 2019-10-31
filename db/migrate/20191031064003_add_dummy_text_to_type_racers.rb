class AddDummyTextToTypeRacers < ActiveRecord::Migration[5.1]
  def change
    add_column :type_racers, :dummy_text, :text
  end
end
