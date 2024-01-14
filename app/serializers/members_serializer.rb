class MembersSerializer < Panko::Serializer
  attributes :id, :name, :image_url, :party_name, :show_info

  def image_url
    object.image_url
  end

  def party_name
    object.political_party.present? ? object.political_party.name : "무소속"
  end
end
