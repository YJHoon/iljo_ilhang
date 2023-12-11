FactoryBot.define do
  factory :error_log do
    content { "MyString" }
    resquest_type { 1 }
    response { "" }
  end
end
