class TypeRaces < ApplicationRecord
belongs_to :race_templates, optional:true
belongs_to :user, optional:true
end
