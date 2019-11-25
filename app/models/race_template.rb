class RaceTemplate < ApplicationRecord
  has_many  :type_races
  validates :text,presence: true
  def is_published
    [true,false].sample
  end
end
