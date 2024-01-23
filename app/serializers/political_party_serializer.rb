class PoliticalPartySerializer < Panko::Serializer
  attributes :id, :name, :average_attendance, :member_count

  # ISSUE: total_member count가 이상하게 나옴
  # ISSUE: 평균 출석률 구할 때, 데이터를 구할 수 없는 경우가 있음

end
