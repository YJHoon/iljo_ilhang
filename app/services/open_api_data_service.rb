class OpenApiDataService
  # attr_reader :get_open_api_data

  # 중앙선거관리위원회 코드정보
  ELECTION_CODE_URL = "http://apis.data.go.kr/9760000/CommonCodeService/getCommonSgCodeList"
  # 중앙선거관리위원회 후보자 정보 호출
  ELECTION_CANDIDATES_URL = "http://apis.data.go.kr/9760000/PofelcddInfoInqireService/getPofelcddRegistSttusInfoInqire"
  # 선거 공약 호출
  ELECTION_PLEDGE_URL = "http://apis.data.go.kr/9760000/ElecPrmsInfoInqireService/getCnddtElecPrmsInfoInqire"
  # 활동중인 의원 정보 호출
  CURRENT_MEMBER_URL = "https://open.assembly.go.kr/portal/openapi/nwvrqwxyaytdsfvhu"

  def initialize()
    @codes = nil
    @candidates = nil
    @members = nil
  end

  def get_election_code
    @codes = "#{ELECTION_CODE_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&numOfRows=1000"
  end

  def get_election_candidates
    sg_id = 20230405
    sg_type_code = 2
    @candidates = "#{ELECTION_CANDIDATES_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&numOfRows=1000&sgId=#{sg_id}&sgTypecode=#{sg_type_code}&numOfRows=1000"
  end

  def get_current_member_data(get_open_api_data_id)
    @members = "#{CURRENT_MEMBER_URL}?key=#{Rails.application.credentials.dig(:open_api_portal_access_key)}&Type=json&pSize=1000"
  end

  private

  def check_current_member_response(response)
    result_code = response.dig(:nwvrqwxyaytdsfvhu).first.dig(:head).second.dig(:RESULT, :CODE)
    return false if result_code == "INFO-000"

    member_list = response.dig(:nwvrqwxyaytdsfvhu).second.dig(:row)

    member_list.each do |member|
      update_member(member)
    end
  end

  def update_member(data)
    data_name, data_birth = data.values_at(:HG_NM, :BTH_DATE)
    member = Member.find_by(name: data_name, birth: data_birth)

    # 마지막 선거 데이터 불러오기
    # 그 선거의 members 불러오기
    # 생일이랑 이름으로 매칭
  end
end
