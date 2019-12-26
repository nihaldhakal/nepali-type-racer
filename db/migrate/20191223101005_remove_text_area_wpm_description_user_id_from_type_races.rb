class RemoveTextAreaWpmDescriptionUserIdFromTypeRaces < ActiveRecord::Migration[5.1]
  def change
    remove_column :type_races, "text_area"
    remove_column :type_races, "wpm"
    remove_column :type_races, "description"
    remove_column :type_races, "user_id"
  end
end
