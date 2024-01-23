FactoryBot.define do
  factory :bill_member do
    member { nil }
    bill { nil }
    name { "MyString" }
    proposer_type { 1 }
  end
end
