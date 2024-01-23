class OpenApi::ElectionDataService < OpenApi::BaseService
  def initialize()
    @response = nil
    @election_list = []
    @code = ""
  end

  def update # 선거 정보 가져오는 코드
    get_election_code()

    begin
      raise Exceptions::OpenApiError, "선거 정보 api response 이슈" if @election_list.empty?

      @election_list.each do |election|
        ActiveRecord::Base.transaction do
          Election.find_or_create_by(sg_id: election.dig("sgId"), sg_type_code: election.dig("sgTypecode")) do |e|
            e.title = election.dig("sgName")
            e.vote_date = election.dig("sgVotedate")
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

  def get_election_code # 선거 코드
    begin
      page_num = 1
      loop do
        response = HTTParty.get("#{OpenApi::BaseService::ELECTION_CODE_URL}?ServiceKey=#{Rails.application.credentials.dig(:public_data_service_key)}&resultType=json&pageNo=#{page_num}&numOfRows=100")
        @response = JSON.parse(response.body)

        ResponseLog.create(msg: "선거 코드 open api", request_type: "open_api", response: @response)
        @code = @response.dig("response", "header", "resultCode")
        break if @code != "INFO-00"
        @election_list += @response.dig("response", "body", "items", "item")
        page_num += 1
      end
    rescue => e
      ErrorLog.create(msg: "[#{@code}] #{e.message}", response: @response)
    end
  end
end
