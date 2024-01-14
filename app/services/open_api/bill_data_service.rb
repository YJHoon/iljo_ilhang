class OpenApi::BillDataService < OpenApi::BaseService
  def initialize()
    @response = nil
    @bill_hash = {}
  end

  def update_bills
    get_bills_data()

    begin
      raise Exceptions::OpenApiError, "현 대수 발의법안 api response 이슈" unless @bill_hash.dig(:list).present?
      raise Exceptions::OpenApiError, "현 대수 발의법안 api response 이슈" if @bill_hash.dig(:response_code) != "INFO-000"

      @bill_hash.dig(:list).each do |bill_data|
        ActiveRecord::Base.transaction do
          bill = Bill.find_or_create_by(bill_id: bill_data.dig("BILL_ID"), bill_no: bill_data.dig("BILL_NO")) do |bill|
            bill.bill_name = bill_data.dig("BILL_NAME")
            bill.age = bill_data.dig("AGE")
            bill.propose_date = bill_data.dig("PROPOSE_DT")
            bill.response = bill_data
          end
          bill_data.dig("PUBL_PROPOSER").gsub(" ", "").split(",").push(bill_data.dig("RST_PROPOSER")).each do |name|
            bill.bill_members.find_or_create_by(member_id: Member.find_by_name(name).id, name: name) do |bill_member|
              bill_member.proposer_type = name == bill_data.dig("RST_PROPOSER") ? "representive" : "public"
            end
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

  def get_bills_data() # 현 대수 발의법안 정보
    page_num = 1 # TODO: page_num 올리면서 발안 없을때까지 loop 돌리기
    response =
      HTTParty.get(
        "#{OpenApi::BaseService::MEMBER_BILLS_URL}?key=#{Rails.application.credentials.dig(:open_api_portal_access_key)}&Type=json&pIndex=#{page_num}&pSize=1000&AGE=#{OpenApi::BaseService::CURRENT_AGE}",
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "*/*",
          "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36",
        },
      )
    @response = JSON.parse(response.body)

    ResponseLog.create(msg: "현 대수 발의법안 open api", request_type: "open_api", response: @response)
    @bill_hash = {
      response_code: @response.dig("nzmimeepazxkubdpn").first.dig("head").second.dig("RESULT", "CODE"),
      list: @response.dig("nzmimeepazxkubdpn").second.dig("row"),
    }
  end
end
