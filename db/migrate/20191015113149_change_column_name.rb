class ChangeColumnName < ActiveRecord::Migration[5.1]
  def up
    change_column :race_templates,  :text, :text
  end

  def down
    change_column :race_templates,  :text, :string
  end

end
