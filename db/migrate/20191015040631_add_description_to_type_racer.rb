class AddDescriptionToTypeRacer < ActiveRecord::Migration[5.1]
  def change
    add_column :type_racers, :description, :string
  end
end
