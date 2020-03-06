class TypeRaceStat < ApplicationRecord
  belongs_to :type_race
  belongs_to :user
  enum status: [:joined,:left, :completed]

end
