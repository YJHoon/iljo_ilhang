class MembersSerializer < Panko::Serializer
  attributes :id, :name, :image_url, :party_name, :attendance

  def party_name
    object.response&.dig("POLY_NM")
  end
end
