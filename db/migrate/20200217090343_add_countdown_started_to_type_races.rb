class AddCountdownStartedToTypeRaces < ActiveRecord::Migration[5.1]

  def up
    add_column  :type_races, :countdown_started, :timestamp
  end

  def down

  end
end
