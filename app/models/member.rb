class Member < ApplicationRecord
  belongs_to :political_party
  belongs_to :election
end
