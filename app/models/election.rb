class Election < ApplicationRecord
  has_many :members, dependent: :destroy
end
