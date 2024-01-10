class OpenApiDataService
  attr_reader :response, :election_hash, :candidate_hash, :member_hash

  # 중앙선거관리위원회 코드정보
  ELECTION_CODE_URL = "http://apis.data.go.kr/9760000/CommonCodeService/getCommonSgCodeList"
  # 중앙선거관리위원회 후보자 정보 호출
  ELECTION_CANDIDATES_URL = "http://apis.data.go.kr/9760000/PofelcddInfoInqireService/getPofelcddRegistSttusInfoInqire"
  # 선거 공약 호출
  ELECTION_PLEDGE_URL = "http://apis.data.go.kr/9760000/ElecPrmsInfoInqireService/getCnddtElecPrmsInfoInqire"
  # 활동중인 의원 정보 호출
  CURRENT_MEMBER_URL = "https://open.assembly.go.kr/portal/openapi/nwvrqwxyaytdsfvhu"
  # 의원 발의법안 호출
  MEMBER_BILLS = "https://open.assembly.go.kr/portal/openapi/nzmimeepazxkubdpn"

  def initialize()
    @response = nil
    @election_hash = {}
    @candidate_hash = {}
    @member_hash = {}
  end

  def update_elections # 선거 정보 가져오는 코드
    get_election_code()

    begin
      raise Exceptions::OpenApiError, "선거 정보 api response 이슈" unless @election_hash.dig(:list).present?
      raise Exceptions::OpenApiError, "선거 정보 api response 이슈" if @election_hash.dig(:response_code) != "INFO-00"

      @election_hash.dig(:list).each do |election|
        Election.find_or_create_by(sg_id: election.dig("sgId"), sg_type_code: election.dig("sgTypecode")) do |e|
          e.title = election.dig("sgName")
          e.vote_date = election.dig("sgVotedate")
        end
      end
    rescue Exceptions::OpenApiError => e
      ErrorLog.create(msg: e.message, response: @response)
    rescue => e
      ErrorLog.create(msg: e.message, response: @response)
    end
  end

  def update_candidates
    Election.all.each do |election|
      begin
        get_election_candidates(election)

        raise Exceptions::OpenApiError, "후보자 정보 api response 이슈" unless @candidate_hash.dig(:list).present?
        raise Exceptions::OpenApiError, "후보자 정보 api response 이슈" if @candidate_hash.dig(:response_code) != "INFO-00"

        next unless @candidate_hash.dig(:response_code).present?

        @candidate_hash.dig(:list).each do |candidate_data|
          political_party = PoliticalParty.find_or_create_by(name: candidate_data.dig("jdName"))
          political_party.candidates.find_or_create_by(election_id: election.id, name: candidate_data.dig("name"), birth: candidate_data.dig("birthday").to_date) do |candidate|
            candidate.region = candidate_data.dig("sdName")
            candidate.gender = UsefulService.valid_gender(candidate_data.dig("gender"))
            candidate.hubo_id = candidate_data.dig("huboid")
            candidate.response = candidate_data
          end
        end
      rescue Exceptions::OpenApiError => e
        ErrorLog.create(msg: e.message, response: @response)
      rescue => e
        ErrorLog.create(msg: e.message, response: @response)
      end
    end
  end

  def update_member
    get_current_member_data()

    begin
      raise Exceptions::OpenApiError, "현 의원 api response 이슈" unless @member_hash.dig(:list).present?
      raise Exceptions::OpenApiError, "현 의원 api response 이슈" if @member_hash.dig(:response_code) != "INFO-000"

      ActiveRecord::Base.transaction do
        Member.update_all(status: "past")
        @member_hash.dig(:list).each do |member_data|
          party = PoliticalParty.find_by_name(member_data.dig("POLY_NM"))
          election = Election.last # TODO: 현재 국회의원들의 election 찾아야함

          Member.find_or_create_by(
            election_id: election.id,
            name: member_data.dig("HG_NM"),
            birth: member_data.dig("BTH_DATE").to_date,
          ).update(political_party_id: party&.id, gender: UsefulService.valid_gender(member_data.dig("SEX_GBN_NM")), status: "current", response: member_data)
        end
      end
    rescue Exceptions::OpenApiError => e
      ErrorLog.create(msg: e.message, response: @response)
    rescue => e
      ErrorLog.create(msg: e.message, response: @response)
    end
  end

  def update_member_bill
  end

  private

  def get_election_code # 선거 코드
    @response = HTTParty.get("#{ELECTION_CODE_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&numOfRows=1000")

    ResponseLog.create(msg: "선거 코드 open api", request_type: "open_api", response: @response)

    @election_hash = {
      response_code: @response.dig("response", "header", "resultCode"),
      list: @response.dig("response", "body", "items", "item"),
    }
  end

  def get_election_candidates(election) # 후보자들 정보(required: 선거코드, 선거타입)
    @response = HTTParty.get("#{ELECTION_CANDIDATES_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&numOfRows=1000&sgId=#{election.sg_id}&sgTypecode=#{election.sg_type_code}&numOfRows=1000")

    ResponseLog.create(msg: "후보자 open api", request_type: "open_api", response: @response)

    @candidate_hash = {
      response_code: @response.dig("getPofelcddRegistSttusInfoInqire", "header", "code"),
      list: @response.dig("getPofelcddRegistSttusInfoInqire", "item"),
    }
  end

  def get_current_member_data # 현 의원 정보
    response =
      HTTParty.get(
        "#{CURRENT_MEMBER_URL}?key=#{Rails.application.credentials.dig(:open_api_portal_access_key)}&Type=json&pSize=1000",
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "*/*",
          "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
        },
      )
    @response = JSON.parse(response)

    ResponseLog.create(msg: "현 의원 open api", request_type: "open_api", response: @response)

    @member_hash = {
      response_code: @response.dig("nwvrqwxyaytdsfvhu").first.dig("head").second.dig("RESULT", "CODE"),
      list: @response.dig("nwvrqwxyaytdsfvhu").second.dig("row"),
    }
  end

  def get_current_member_data # 현 의원 정보
    response =
      HTTParty.get(
        "#{MEMBER_BILLS}?key=#{Rails.application.credentials.dig(:open_api_portal_access_key)}&Type=json&pSize=1000",
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "*/*",
          "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
        },
      )
    @response = JSON.parse(response)

    ResponseLog.create(msg: "현 의원 open api", request_type: "open_api", response: @response)

    @member_hash = {
      response_code: @response.dig("nwvrqwxyaytdsfvhu").first.dig("head").second.dig("RESULT", "CODE"),
      list: @response.dig("nwvrqwxyaytdsfvhu").second.dig("row"),
    }
  end
end
