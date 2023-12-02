class PoliticalParty < ApplicationRecord
  has_many :members, dependent: :destroy
end
