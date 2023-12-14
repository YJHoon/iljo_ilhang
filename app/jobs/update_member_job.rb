class UpdateMemberJob < ApplicationJob
  queue_as :default

  def perform(*args)
    update_data = CrawlingService.new.check_open_api_update_date

    return if update_data == "" # TODO: 캐싱된 마지막 업데이트 날짜 가져오기

    # 캐싱된거랑 다를 경우 업데이트 진행
    OpenApiDataService.new.update_member
  end
end
