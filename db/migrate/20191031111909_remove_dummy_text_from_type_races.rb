class RemoveDummyTextFromTypeRaces < ActiveRecord::Migration[5.1]
  def change
    remove_column :type_races, :dummy_text, :text
  end
end
