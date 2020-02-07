class TypeRace < ApplicationRecord
  belongs_to :race_template, optional:true
  has_many :type_race_stats
  has_many :users, through: :type_race_stats
  enum status: [:pending,:countdown_is_set,:ongoing,:canceled, :completed]
end
