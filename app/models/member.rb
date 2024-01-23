class Member < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :political_party, optional: true, counter_cache: :members_count # TODO: counter cache 동작 안 함. 체크해보기
  belongs_to :election

  has_many :bill_members
  has_many :representive_bill_members, -> { where(proposer_type: "representive") }, class_name: "BillMember"
  has_many :bills, through: :bill_members, source: :bill
  has_many :representive_bills, through: :representive_bill_members, source: :bill

  enum gender: { male: 0, female: 1 }
  enum status: { past: 0, current: 1 }

  def self.where_ko_or_ch_name(name)
    where("name = ? OR response ->> 'HJ_NM' = ?", name, name)
  end

  def self.calc_average_attendance
    rate_list = self.pluck(:attendance).compact
    return nil if rate_list.empty?
    return (rate_list.sum / rate_list.size).round(2)
  end
end
