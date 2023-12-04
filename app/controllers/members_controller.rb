class MembersController < ApplicationController
  def create
    Member.create!(permit_params)
  end

  private

  def permit_params
    params.permit(:name, :image)
  end
end
