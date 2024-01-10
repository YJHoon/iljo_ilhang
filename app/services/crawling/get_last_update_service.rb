class Crawling::GetLastUpdateService < Crawling::BaseService
  def open_api_member # 국회의원 인적사항 마지막 업데이트 일시 체크
    begin
      headers = { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" }
      scrap_url = "https://open.assembly.go.kr/portal/data/service/selectAPIServicePage.do/OWSSC6001134T516707#none"
      document = scrap_page(scrap_url, headers)
      document.css("section#metaInfo table tbody tr:nth-child(2) td:nth-child(4)").first.children.text
    rescue => e
      ErrorLog.create(msg: "마지막 업데이트 일시 체크: #{e.message}")
    end
  end
end
