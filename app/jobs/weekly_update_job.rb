class WeeklyUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # TODO: 매주 update 해야하는 코드 작성. ex) 열려라 국회 상세페이지
    crawling_umd = Crawling::UpdateMemberDataService.new
    crawling_umd.update_member_image_and_seq_id
    crawling_umd.update_member_show_info
  end
end
