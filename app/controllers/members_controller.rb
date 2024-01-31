class MembersController < ApplicationController
  def index
    render json: {
             parties: each_serializer(PoliticalParty.all, PoliticalPartySerializer),
             members: each_serializer(Member.current.all, MembersSerializer),
           }
  end

  def show
    member = Member.find(params[:id])
    render json: serializer(member, MemberSerializer)
  end

end
