class UpdateMembersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    update_date = Crawling::GetLastUpdateService.new.open_api_member

    return if update_date == Rails.cache.read(Crawling::BaseService::MEMBER_DATA_UPDATE_CACHE_KEY)

    result = OpenApi::MemberDataService.new.update
    Rails.cache.write(Crawling::BaseService::MEMBER_DATA_UPDATE_CACHE_KEY, update_date) if result
  end
end
