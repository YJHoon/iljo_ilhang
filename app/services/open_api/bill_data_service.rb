class OpenApi::BillDataService < OpenApi::BaseService
  attr_reader :bill_list, :code, :response

  def initialize()
    @response = nil
    @bill_list = []
    @code = ""
  end

  def update
    get_bills_data()

    begin
      raise Exceptions::OpenApiError, "현 대수 발의법안 api response 이슈" if @bill_list.empty?

      @bill_list.each do |bill_data|
        ActiveRecord::Base.transaction do
          bill = Bill.find_or_create_by(bill_id: bill_data.dig("BILL_ID"), bill_no: bill_data.dig("BILL_NO")) do |b|
            b.bill_name = bill_data.dig("BILL_NAME")
            b.age = bill_data.dig("AGE")
            b.propose_date = bill_data.dig("PROPOSE_DT")
            b.proc_result = bill_data.dig("PROC_RESULT")
            b.response = bill_data
          end

          bill.bill_members.find_or_create_by(member_id: Member.find_by_name(bill_data.dig("RST_PROPOSER"))&.id, name: bill_data.dig("RST_PROPOSER")) do |bill_member|
            break if bill_member.member_id.nil?
            bill_member.proposer_type = "representive"
          end
          # name_list = [bill_data.dig("RST_PROPOSER")] + bill_data.dig("PUBL_PROPOSER")&.gsub(" ", "")&.split(",").to_a
          # name_list.each do |name|
          #   next unless name.present?
          #   bill.bill_members.find_or_create_by(member_id: Member.find_by_name(name)&.id, name: name) do |bill_member|
          #     break if bill_member.member_id.nil?
          #     bill_member.proposer_type = ((name == bill_data.dig("RST_PROPOSER")) ? "representive" : "public")
          #   end
          # end

        end
      end
      return true
    rescue Exceptions::OpenApiError => e
      ErrorLog.create(msg: e.message, response: @response)
      return false
    rescue => e
      ErrorLog.create(msg: e.message, response: @response)
      return false
    end
  end

  private

  def get_bills_data() # 현 대수 발의법안 정보
    begin
      page_num = 1
      loop do
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

        @code = @response.dig("nzmimeepazxkubdpn").first.dig("head").second.dig("RESULT", "CODE")
        break if @code != "INFO-000"
        @bill_list += @response.dig("nzmimeepazxkubdpn").second.dig("row")
        page_num += 1
      end
    rescue => e
      ErrorLog.create(msg: "[#{@code}] #{e.message}", response: @response)
    end
  end
end
