class DailyUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # TODO: 매일 update 해야하는 코드 작성. ex) 열려라 국회 상세페이지
  end
end
