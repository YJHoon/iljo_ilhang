class MembersController < ApplicationController
  def index
    cached_members = Rails.cache.read(Member::ALL_CACHE_KEY)

    render json: cached_members and return if cached_members.present?

    members = Member.current.all
    Rails.cache.write(Member::ALL_CACHE_KEY, each_serializer(members, MembersSerializer))

    render json: each_serializer(members, MembersSerializer)
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
