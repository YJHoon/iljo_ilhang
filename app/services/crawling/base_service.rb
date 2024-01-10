module Crawling
  class BaseService
    MEMBER_DATA_UPDATE_CACHE_KEY = "open_api_members_update_date"
    BILL_DATA_UPDATE_CACHE_KEY = "open_api_bills_update_date"

    protected

    def scrap_page(url, headers = {})
      response = HTTParty.get(url, headers: headers)
      document = Nokogiri::HTML(response.body)
      ResponseLog.create(msg: "크롤링 url: #{url}", request_type: "crawling")

      return document
    end
  end
end
