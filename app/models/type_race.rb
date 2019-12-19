class TypeRace < ApplicationRecord
  belongs_to :race_templates, optional:true
  has_and_belongs_to_many :users
  enum status: [:pending,:countdown_is_set,:ongoing,:completed]
end
