class Candidate < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :political_party
  belongs_to :election

  enum gender: { male: 0, female: 1 }
  enum status: { candidate: 0, current: 1 }

  before_save :check_gender_value, :if => :gender_changed?

  def check_gender_value
    if ["남", "남성", "man", "male"].include?(self.gender)
      self.gender = "male"
    else
      self.gender = "female"
    end
  end
end
