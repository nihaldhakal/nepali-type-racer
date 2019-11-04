class AddRaceTemplatesIdToTypeRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :type_races, :race_templates_id, :integer
  end
end
