class PoliticalPartiesController < ApplicationController
  def create
    PoliticalParty.create(permit_params)
  end

  private

  def permit_params
    params.permit(:name, :banner_image)
  end
end
