class MemberSerializer < Panko::Serializer
  attributes :profile, :attendance, :election_info, :bill_info

  def profile
    {
      id: object.id,
      name: object.name,
      image_url: object.image_url,
      party_name: self.party_name,
      committee: self.committee,
      region: self.region,
      units: self.units,
      history: self.history,

    }
  end

  def bill_info
    {
      status: object.representive_bills.pluck(:proc_result).tally,
      list: Panko::ArraySerializer.new(object.representive_bills, each_serializer: BillsSerializer).to_json,
    }
  end

  def attendance
    {
      main_attendance: object.attendance,
      total_average_attendance: Member.current.calc_average_attendance,
    }
  end

  def election_info
    object.show_info&.dig("선거정보")
  end

  private

  def party_name
    object.political_party.present? ? object.political_party.name : "무소속"
  end

  def committee
    object.response&.dig("CMIT_NM")
  end

  def region
    object.response&.dig("ORIG_NM")
  end

  def units
    object.response&.dig("UNITS")
  end

  def history
    object.response&.dig("MEM_TITLE")
  end
end
