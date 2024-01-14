class OpenApi::CandidateDataService < OpenApi::BaseService
  def initialize()
    @response = nil
    @candidate_list = []
    @code = ""
    @page_num = 1
  end

  def update_candidates
    # TODO: 최근 선거 찾아야함 특정 선거 찾아야 함
    election = Election.find(132)
    begin
      get_election_candidates(election)

      raise Exceptions::OpenApiError, "후보자 정보 api response 이슈" if @candidate_list.empty?

      @candidate_list.each do |candidate_data|
        ActiveRecord::Base.transaction do
          political_party = PoliticalParty.find_or_create_by(name: candidate_data.dig("jdName"))
          political_party.candidates.find_or_create_by(election_id: election.id, name: candidate_data.dig("name"), birth: candidate_data.dig("birthday").to_date) do |candidate|
            candidate.region = candidate_data.dig("sdName")
            candidate.gender = UsefulService.valid_gender(candidate_data.dig("gender"))
            candidate.hubo_id = candidate_data.dig("huboid")
            candidate.response = candidate_data
          end
        end
      end
    rescue Exceptions::OpenApiError => e
      ErrorLog.create(msg: e.message, response: @response)
    rescue => e
      ErrorLog.create(msg: e.message, response: @response)
    end
  end

  private

  def get_election_candidates(election) # 후보자들 정보(required: 선거코드, 선거타입)
    begin
      loop do
        response = HTTParty.get("#{OpenApi::BaseService::ELECTION_CANDIDATES_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&sgId=#{election.sg_id}&sgTypecode=#{election.sg_type_code}&pageNo=#{@page_num}&numOfRows=100")
        @response = JSON.parse(response.body)

        ResponseLog.create(msg: "후보자 open api", request_type: "open_api", response: @response)
        break if @response.dig("getPofelcddRegistSttusInfoInqire", "header", "code") != "INFO-00"
        @candidate_list += @response.dig("getPofelcddRegistSttusInfoInqire", "item")
        @page_num += 1
      end
      @code = @response.dig("getPofelcddRegistSttusInfoInqire", "header", "code")
    rescue => e
      ErrorLog.create(msg: e.message, response: @response)
    end
  end
end
