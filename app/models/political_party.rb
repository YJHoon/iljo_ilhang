class PoliticalParty < ApplicationRecord
  mount_uploader :banner_image, ImageUploader
  mount_uploader :logo_image, ImageUploader

  has_many :members, dependent: :destroy
  has_many :candidates, dependent: :destroy
end
