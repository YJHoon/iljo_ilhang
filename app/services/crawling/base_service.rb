module Crawling
  class BaseService
    attr_reader :member_list

    MEMBER_DATA_UPDATE_CACHE_KEY = "open_api_members_update_date".freeze # 국회의원 정보 마지막 수정 날짜
    BILL_DATA_UPDATE_CACHE_KEY = "open_api_bills_update_date".freeze # 발의법안 마지막 수정 날짜
    OPEN_ASSEMBLY_MEMBER_LIST_CACHE_KEY = "open_assembly_member_list".freeze

    def initialize
      @page_num = 1
      @member_list = Rails.cache.read(OPEN_ASSEMBLY_MEMBER_LIST_CACHE_KEY) || Nokogiri::XML::NodeSet.new(Nokogiri::XML::Document.new)

      get_member_list() if @member_list.empty?
    end

    protected

    def scrap_page(url, headers = {})
      response = HTTParty.get(url, headers: headers)
      document = Nokogiri::HTML(response.body)
      ResponseLog.create(msg: "크롤링 url: #{url}", request_type: "crawling")

      return document
    end

    def get_member_list
      loop do
        url = "https://watch.peoplepower21.org/?mid=AssemblyMembers&mode=search&party=&region=&sangim=&gender=&elect_num=&page=#{@page_num}#watch"
        document = scrap_page(url)
        break if document.css("div#content div.col-md-2").size.zero?

        @member_list += document.css("div#content div.col-md-2")
        @page_num += 1
      end
    end
  end
end
