class TypeRaces < ApplicationRecord
belongs_to  :race_templates, optional: true
end
