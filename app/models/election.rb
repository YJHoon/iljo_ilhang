class Election < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :candidates, dependent: :destroy
end
