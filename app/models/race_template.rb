class RaceTemplate < ApplicationRecord
  has_many  :type_races
  validates :text,presence: true

end
