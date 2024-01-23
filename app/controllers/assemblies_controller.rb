class AssembliesController < ApplicationController
  def index
    members = Member.current.all
    parties = PoliticalParty.all
    render json: {
             parties: each_serializer(parties, PoliticalPartySerializer),
             members: each_serializer(members, MembersSerializer),
           }
  end
end
