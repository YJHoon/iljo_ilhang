class MembersController < ApplicationController
  def index
    members = Member.current.all

    render json: {
             parties: each_serializer(PoliticalParty.all, PoliticalPartySerializer),
             members: each_serializer(members, MembersSerializer, context: { average_attendance: members.calc_average_attendance }),
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
