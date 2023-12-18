class CrawlingService
  PERMIT_IMAGE_FORMAT = %w[png jpg jpeg].freeze

  def initialize
    @page_num = 1
  end

  def check_open_api_update_date # 마지막 업데이트 일시 체크
    begin
      headers = { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" }
      scrap_url = "https://open.assembly.go.kr/portal/data/service/selectAPIServicePage.do/OWSSC6001134T516707#none"
      document = scrap_page(scrap_url, headers)
      document.css("section#metaInfo table tbody tr:nth-child(2) td:nth-child(4)").first.children.text
    rescue => e
      ErrorLog.create(msg: "마지막 업데이트 일시 체크: #{e.message}")
    end
  end

  def page_scrapping_for_image_update # 국회의원 이미지 업데이트
    begin
      loop do
        scrap_url = "https://watch.peoplepower21.org/?mid=AssemblyMembers&mode=search&party=&region=&sangim=&gender=&elect_num=&page=#{@page_num}#watch"
        document = scrap_page(scrap_url)
        member_list = document.css("div#content div.col-md-2")
        break if member_list.size.zero?

        update_member_image(member_list)
        @page_num += 1
      end
    rescue => e
      ErrorLog.create(msg: "국회의원 이미지 업데이트: #{e.message}")
    end
  end

  private

  def scrap_page(url, headers = {})
    response = HTTParty.get(url, headers: headers)
    document = Nokogiri::HTML(response.body)
    ResponseLog.create(msg: "크롤링 url: #{url}", request_type: "crawling")

    return document
  end

  def update_member_image(member_list)
    member_list.each do |data|
      image_url = data.css("a img").first.attribute("src").value
      name = data.css("a h4").first.text.split.last

      is_image = get_content_type(image_url)
      next unless is_image
      temp_image = convert_url_to_image(image_url)

      member = Member.find_by_name(name)
      member.update(image: temp_image) if member.present?
    end
  end

  def convert_url_to_image(image_url)
    uri = URI.parse(image_url)
    image = uri.open

    return image
  end

  def get_content_type(image_url)
    ext_name = File.extname(image_url).delete(".")
    return false unless PERMIT_IMAGE_FORMAT.include?(ext_name)

    "image/#{ext_name}"
  end
end
