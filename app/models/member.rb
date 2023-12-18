class Member < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :political_party, optional: true
  belongs_to :election

  enum gender: { male: 0, female: 1 }
  enum status: { past: 0, current: 1 }
end
