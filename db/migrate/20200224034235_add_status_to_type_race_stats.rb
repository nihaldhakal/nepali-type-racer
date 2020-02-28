class AddStatusToTypeRaceStats < ActiveRecord::Migration[5.1]
  def up
    add_column :type_race_stats, :status, :integer, default:0
  end

  def down

  end
end
