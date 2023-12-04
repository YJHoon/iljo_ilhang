require 'test_helper'

class CrawlingServiceTest < ActiveSupport::TestCase
  setup do
    @crawling = CrawlingService.create!()
  end

  test "crawling 생성" do
    crawling_id = @crawling.id
    service = CrawlingService.new(crawling_id)
    pp service.build_crawling(crawling_id).attributes
  end
end
