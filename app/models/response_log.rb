class ResponseLog < ApplicationRecord
  OPEN_ASSEMBPLY_RESPONSE_TYPE = [
    { code: "300", type: "ERROR", message: "필수 값이 누락되어 있습니다. 요청인자를 참고 하십시오." },
    { code: "290", type: "ERROR", message: "인증키가 유효하지 않습니다. 인증키가 없는 경우, 홈페이지에서 인증키를 신청하십시오." },
    { code: "337", type: "ERROR", message: "일별 트래픽 제한을 넘은 호출입니다. 오늘은 더이상 호출할 수 없습니다." },
    { code: "310", type: "ERROR", message: "해당하는 서비스를 찾을 수 없습니다. 요청인자 중 SERVICE를 확인하십시오." },
    { code: "333", type: "ERROR", message: "요청위치 값의 타입이 유효하지 않습니다.요청위치 값은 정수를 입력하세요." },
    { code: "336", type: "ERROR", message: "데이터요청은 한번에 최대 1,000건을 넘을 수 없습니다." },
    { code: "500", type: "ERROR", message: "서버 오류입니다. 지속적으로 발생시 홈페이지로 문의(Q&A) 바랍니다." },
    { code: "600", type: "ERROR", message: "데이터베이스 연결 오류입니다. 지속적으로 발생시 홈페이지로 문의(Q&A) 바랍니다." },
    { code: "601", type: "ERROR", message: "SQL 문장 오류 입니다. 지속적으로 발생시 홈페이지로 문의(Q&A) 바랍니다." },
    { code: "990", type: "ERROR", message: "인증서가 폐기되었습니다.홈페이지에서 인증키를 확인하십시오." },
    { code: "000", type: "INFO", message: "정상 처리되었습니다." },
    { code: "300", type: "INFO", message: "관리자에 의해 인증키 사용이 제한되었습니다." },
    { code: "200", type: "INFO", message: "해당하는 데이터가 없습니다." },
  ].freeze

  DATA_PORTAL_ERROR_TYPE = [
    { code: "1", type: "ERROR", message: "APPLICATION ERROR	어플리케이션 에러" },
    { code: "4", type: "ERROR", message: "HTTP_ERROR	HTTP 에러" },
    { code: "12", type: "ERROR", message: "NO_OPENAPI_SERVICE_ERROR	해당 오픈 API 서비스가 없거나 폐기됨" },
    { code: "20", type: "ERROR", message: "SERVICE_ACCESS_DENIED_ERROR	서비스 접근거부" },
    { code: "22", type: "ERROR", message: "LIMITED_NUMBER_OF_SERVICE_REQUESTS_EXCEEDS_ERROR	서비스 요청제한횟수 초과에러" },
    { code: "30", type: "ERROR", message: "SERVICE_KEY_IS_NOT_REGISTERED_ERROR	등록되지 않은 서비스키" },
    { code: "31", type: "ERROR", message: "DEADLINE_HAS_EXPIRED_ERROR	활용기간 만료" },
    { code: "32", type: "ERROR", message: "UNREGISTERED_IP_ERROR	등록되지 않은 IP" },
    { code: "99", type: "ERROR", message: "UNKNOWN_ERROR	기타에러" },
  ].freeze

  enum request_type: { open_api: 0, crawling: 1 }

  def self.matching_response_message(code, type: "data_portal")
    if type == "data_portal"
      DATA_PORTAL_ERROR_TYPE.filter { |q| q[:code] == code }.first
    else
      OPEN_ASSEMBPLY_RESPONSE_TYPE.filter { |q| q[:code] == code }.first
    end
  end
end
