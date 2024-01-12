class UpdateBillsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    update_date = Crawling::GetLastUpdateService.new.open_api_bill

    return if update_date == Rails.cache.read(Crawling::BaseService::BILL_DATA_UPDATE_CACHE_KEY)

    Rails.cache.write(Crawling::BaseService::BILL_DATA_UPDATE_CACHE_KEY, update_date)

    # 캐싱된거랑 다를 경우 업데이트 진행
    OpenApi::BillDataService.new.update_bills
  end
end
