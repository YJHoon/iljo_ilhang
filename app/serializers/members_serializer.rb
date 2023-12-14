class MembersSerializer < Panko::Serializer
  attributes :id, :name, :image

  has_one :political_party, serializer: PoliticalPartySerializer
end
