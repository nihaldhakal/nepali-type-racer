class TimestampToTypeRaces < ActiveRecord::Migration[5.1]
    def up
      add_column :type_races, :timestamps, :datetime
    end

    def down

    end
end
