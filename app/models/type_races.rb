class TypeRaces < ApplicationRecord
  belongs_to :race_templates, optional:true
  has_and_belongs_to_many :users
  enum status: [:pending,:completed,:ongoing]
end
