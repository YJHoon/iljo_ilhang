class OpenApi::ElectionDataService < OpenApi::BaseService
  def initialize()
    @response = nil
    @election_hash = {}
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

  private

  def get_election_code # 선거 코드
    @response = HTTParty.get("#{OpenApi::BaseService::ELECTION_CODE_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&numOfRows=1000")

    ResponseLog.create(msg: "선거 코드 open api", request_type: "open_api", response: @response)

    @election_hash = {
      response_code: @response.dig("response", "header", "resultCode"),
      list: @response.dig("response", "body", "items", "item"),
    }
  end
end
