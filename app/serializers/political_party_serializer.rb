class PoliticalPartySerializer < Panko::Serializer
  attributes :id, :name, :average_attendance, :total_member, :leader

  def total_member
    object.members.current.size
  end

  def average_attendance
    rate_list = object.members.pluck(:attendance).compact
    return nil if rate_list.empty?
    (rate_list.sum / rate_list.size).round(2)
  end

  # ISSUE: total_member count가 이상하게 나옴
  # ISSUE: 평균 출석률 구할 때, 데이터를 구할 수 없는 경우가 있음

end
