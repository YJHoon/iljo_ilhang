class MembersController < ApplicationController
  def index
    members = Member.current.all

    render json: {
             parties: each_serializer(PoliticalParty.all, PoliticalPartySerializer),
             members: each_serializer(members, MembersSerializer),
           }
  end

  def show
    member = Member.find(params[:id])

    render json: serializer(member, MemberSerializer)
  end

  private

  def permit_params
    params.permit(:name, :image)
  end
end
