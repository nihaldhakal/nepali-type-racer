class RemoveTimestampsAndCountdownStartedFromTypeRaces < ActiveRecord::Migration[5.1]
  def up
    remove_column :type_races, :timestamps, :datetime
    remove_column  :type_races, :countdown_started, :datetime
  end

  def down

  end
end
