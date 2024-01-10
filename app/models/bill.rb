class Bill < ApplicationRecord
  has_many :bill_members, dependent: :destroy
  has_many :representive_bill_members, -> { where(proposer_type: "representive") }, class_name: "BillMember"
  has_many :members, through: :bill_members, source: :member
  has_many :representive_members, through: :representive_bill_members, source: :member
end
