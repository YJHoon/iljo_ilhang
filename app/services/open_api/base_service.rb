module OpenApi
  class BaseService
    # 현 의원 대수
    CURRENT_AGE = 21
    # 중앙선거관리위원회 코드정보
    ELECTION_CODE_URL = "http://apis.data.go.kr/9760000/CommonCodeService/getCommonSgCodeList"
    # 중앙선거관리위원회 후보자 정보 호출
    ELECTION_CANDIDATES_URL = "http://apis.data.go.kr/9760000/PofelcddInfoInqireService/getPofelcddRegistSttusInfoInqire"
    # 선거 공약 호출
    ELECTION_PLEDGE_URL = "http://apis.data.go.kr/9760000/ElecPrmsInfoInqireService/getCnddtElecPrmsInfoInqire"
    # 활동중인 의원 정보 호출
    CURRENT_MEMBER_URL = "https://open.assembly.go.kr/portal/openapi/nwvrqwxyaytdsfvhu"
    # 의원 발의법안 호출
    MEMBER_BILLS_URL = "https://open.assembly.go.kr/portal/openapi/nzmimeepazxkubdpn"
  end
end
