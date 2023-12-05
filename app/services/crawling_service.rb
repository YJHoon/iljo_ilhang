class CrawlingService
  PERMIT_IMAGE_FORMAT = %w[png jpg jpeg].freeze
  # 중앙선거관리위원회 코드정보
  ELECTION_CODE_URL = "http://apis.data.go.kr/9760000/CommonCodeService/getCommonSgCodeList"
  # 중앙선거관리위원회 후보자 정보 호출
  ELECTION_CANDIDATES_URL = "http://apis.data.go.kr/9760000/PofelcddInfoInqireService/getPofelcddRegistSttusInfoInqire"
  # 선거 공약 호출
  ELECTION_PLEDGE_URL = "http://apis.data.go.kr/9760000/ElecPrmsInfoInqireService/getCnddtElecPrmsInfoInqire"
  # 활동중인 의원 정보 호출
  CURRENT_MEMBER_URL = "https://open.assembly.go.kr/portal/data/service/selectAPIServicePage.do/OWSSC6001134T516707"

  def initialize
    @crawling = nil
    @page_num = 1
  end

  def scrap_page(url)
    response = HTTParty.get(scrap_url)
    document = Nokogiri::HTML(response.body)
    return document
  end

  def check_open_api_update()
    # document = scrap_page(CURRENT_MEMBER_URL)

    response = HTTParty.get("https://open.assembly.go.kr/portal/data/service/selectAPIServicePage.do/OWSSC6001134T516707#none")
    document = Nokogiri::HTML(response.body)
    document.css("section#metaInfo tbody tr").second.css("td").second
  end

  def page_scrapping_for_image_update # 국회의원 이미지 업데이트
    loop do
      scrap_url = "https://watch.peoplepower21.org/?mid=AssemblyMembers&mode=search&party=&region=&sangim=&gender=&elect_num=&page=#{@page_num}#watch"
      document = scrap_page(scrap_url)
      member_list = document.css("div#content div.col-md-2")
      break if member_list.size.zero?

      update_member_image(member_list)
      @page_num += 1
    end
  end

  private

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
