class Candidate < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :political_party, optional: true
  belongs_to :election

  enum gender: { male: 0, female: 1 }
  enum status: { accept: 0, dead: 1, retirement: 2 }
end
