class BillMember < ApplicationRecord
  belongs_to :member
  belongs_to :bill

  enum proposer_type: { representive: 0, public: 1 }, _prefix: true
end
