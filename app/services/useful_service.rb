class UsefulService
  attr_reader :useful

  GENDERS = {
    "남" => "male",
    "남성" => "male",
    "man" => "male",
    "여" => "female",
    "여성" => "female",
    "woman" => "female",
  }.freeze

  def initialize(useful_id)
    @useful = nil
  end

  def self.valid_gender(gender)
    GENDERS[gender]
  end
end
