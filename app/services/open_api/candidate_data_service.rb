class OpenApi::CandidateDataService < OpenApi::BaseService
  def initialize()
    @response = nil
    @candidate_hash = {}
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

  private

  def get_election_candidates(election) # 후보자들 정보(required: 선거코드, 선거타입)
    @response = HTTParty.get("#{OpenApi::BaseService::ELECTION_CANDIDATES_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&numOfRows=1000&sgId=#{election.sg_id}&sgTypecode=#{election.sg_type_code}&numOfRows=1000")

    ResponseLog.create(msg: "후보자 open api", request_type: "open_api", response: @response)

    @candidate_hash = {
      response_code: @response.dig("getPofelcddRegistSttusInfoInqire", "header", "code"),
      list: @response.dig("getPofelcddRegistSttusInfoInqire", "item"),
    }
  end
end
