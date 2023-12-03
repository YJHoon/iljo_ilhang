class Candidate < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :political_party
  belongs_to :election
end
