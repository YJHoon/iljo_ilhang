class MembersController < ApplicationController
  def index
    members = Member.current.all
    render json: each_serializer(members, MembersSerializer)
  end

  private

  def permit_params
    params.permit(:name, :image)
  end
end
