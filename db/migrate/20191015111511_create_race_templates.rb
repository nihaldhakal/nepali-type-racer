class CreateRaceTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :race_templates do |t|
      t.string :text

      t.timestamps
    end
  end
end
