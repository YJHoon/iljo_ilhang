class MembersSerializer < Panko::Serializer
  attributes :id, :name, :image_url, :party_name, :attendance, :election_info, :bills

  def image_url
    object.image_url
  end

  def party_name
    object.political_party.present? ? object.political_party.name : "무소속"
  end

  def election_info
    object.show_info&.dig("선거정보")
  end

  def bills
    object.representive_bills
  end
end
