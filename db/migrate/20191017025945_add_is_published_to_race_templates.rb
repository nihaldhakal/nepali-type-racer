class AddIsPublishedToRaceTemplates < ActiveRecord::Migration[5.1]
  def change
    add_column :race_templates, :is_published, :boolean
  end
end
