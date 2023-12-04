class Member < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :political_party
  belongs_to :election

  enum gender: { male: 0, female: 1 }
  enum status: { candidate: 0, current: 1 }

  def self.get
  end
end
