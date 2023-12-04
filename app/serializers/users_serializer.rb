class UsersSerializer < Panko::Serializer
  attributes :id, :name, :email, :birth, :phone, :gender
end
