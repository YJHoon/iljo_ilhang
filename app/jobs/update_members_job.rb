class UpdateMembersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    update_date = Crawling::GetLastUpdateService.new.open_api_member

    return if update_date == Rails.cache.read(Crawling::BaseService::MEMBER_DATA_UPDATE_CACHE_KEY)

    Rails.cache.write(Crawling::BaseService::MEMBER_DATA_UPDATE_CACHE_KEY, update_date)

    # 캐싱된거랑 다를 경우 업데이트 진행
    OpenApi::MemberDataService.new.update_members
    crawling_update_member = Crawling::UpdateMemberDataService.new
    crawling_update_member.update_member_image
    crawling_update_member.update_member_seq_id
  end
end
