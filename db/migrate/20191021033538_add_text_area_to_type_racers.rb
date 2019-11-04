class AddTextAreaToTypeRacers < ActiveRecord::Migration[5.1]
  def change
    add_column :type_races, :text_area, :text
  end
end
