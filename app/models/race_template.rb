class RaceTemplate < ApplicationRecord
  has_many  :type_races
  validates :text,presence: true
  def is_publishedo
    [true,false].sample
  end
end
