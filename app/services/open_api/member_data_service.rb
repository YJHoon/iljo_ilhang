class OpenApi::MemberDataService < OpenApi::BaseService
  def initialize()
    @response = nil
    @member_hash = {}
  end

  def update_members
    get_current_member_data()

    begin
      raise Exceptions::OpenApiError, "현 의원 api response 이슈" unless @member_hash.dig(:list).present?
      raise Exceptions::OpenApiError, "현 의원 api response 이슈" if @member_hash.dig(:response_code) != "INFO-000"

      ActiveRecord::Base.transaction do
        Member.update_all(status: "past")
        @member_hash.dig(:list).each do |member_data|
          party = PoliticalParty.find_or_create_by(name: member_data.dig("POLY_NM"))
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

  private

  def get_current_member_data # 현 의원 정보
    response =
      HTTParty.get(
        "#{OpenApi::BaseService::CURRENT_MEMBER_URL}?key=#{Rails.application.credentials.dig(:open_api_portal_access_key)}&Type=json&pSize=1000",
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
