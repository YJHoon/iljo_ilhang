class MembersController < ApplicationController
  def index
    cached_members = Rails.cache.read(cache_key)

    if cached_members.present?
      members = cached_members
    else
      members = Member.current.all
      Rails.cache.write(Member::CACHE_KEY, members)
    end

    render json: members
  end

  def update_caching
    members = Member.current.all

    Rails.cache.write(Member::CACHE_KEY, members)
  end

  private

  def permit_params
    params.permit(:name, :image)
  end
end
