class UsersController < ApplicationController
  def create
    User.create(permit_params)

    render json: each_serializer(users, UsersSerializer)
  end

  private

  def permit_params
    params.permit(:name, :email, :phone, :birth, :gender, :uid, :response, :access_token)
  end
end
