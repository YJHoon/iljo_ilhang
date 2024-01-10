class Bill < ApplicationRecord
  has_many :bill_members, dependent: :destroy
  has_many :members, through: :bill_members
end
