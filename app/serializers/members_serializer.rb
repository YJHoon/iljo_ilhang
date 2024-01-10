class MembersSerializer < Panko::Serializer
  attributes :id, :name, :image, :party_name

  def party_name
    object.political_party.present? ? object.political_party.name : "무소속"
  end
end
