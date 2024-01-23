class Crawling::UpdateMemberDataService < Crawling::BaseService
  PERMIT_IMAGE_FORMAT = %w[png jpg jpeg].freeze

  def initialize
    super
  end

  def update_member_image_and_seq_id # 국회의원 이미지 업데이트
    begin
      @member_list.each do |data|
        image_url = data.css("a img").first.attribute("src").value
        name = data.css("a h4").first.text.split.last
        match = data.css("a").first["href"].match(/&member_seq=(.*)/)
        seq_id = match ? match[1] : nil

        is_image = get_content_type(image_url)
        temp_image = convert_url_to_image(image_url)

        member = matching_member(name, seq_id)
        if member.present?
          member.image = temp_image
          member.seq_id = seq_id
          member.save
        end
      end
    rescue => e
      ErrorLog.create(msg: "열려라국회 국회의원 이미지, seq_id 업데이트: #{e.message}")
    end
  end

  def update_member_show_info
    Member.current.each do |member|
      begin
        raise ActiveRecord::RecordNotFound, "member #{member.id}의 seq_id를 찾을 수 없습니다." if member.seq_id.nil?
        document = scrap_member_show_page(member.seq_id)

        document.css(".panel-group").children.css("div.panel").each do |panel|
          title = panel.css("h4.panel-title a").children.first.text.gsub(/\s+/, " ").strip.match(/\d+\.\s(.+)$/)[1]

          case title
          when "본회의 활동"
            member.attendance = panel.css(".panel-body > h3").first&.text&.strip&.gsub("%", "")&.split(" ")&.last.to_f
          when "선거정보"
            _, total_vote, available_vote = panel.css(".panel-body > div").first&.text&.strip.gsub(/\s+/, " ").gsub(",", "").split().filter { |a| !a.to_i.zero? }.map(&:to_i)
            _, member_gain_vote, _ = panel.css(".panel-body span.iGraph3 span.gBar").first.text.gsub(",", "").split().filter { |a| !a.to_i.zero? }.map(&:to_i)

            # 지역구 투표율 = 총투표수 / 전체유권자)
            # 지역구 내 의원 특표율 = 득표수 / 총투표수
            ## 필요 속성: 전체유권자(available_vote), 투표수(total_vote), 해당 의원득표수(member_gain_vote)
            member.show_info = {
              "선거정보": {
                "전체유권자": available_vote,
                "총투표수": total_vote,
                "득표수": member_gain_vote,
              },
            }
          when "선거정보 (비례)"
            # TODO: 비례는 iframe 내부에 정보가 있어서 web driver 이용해서 로딩 이후 가져오는식으로 해야할듯?
          else
          end
        end

        member.save
      rescue => e
        ErrorLog.create(msg: "열려라국회 국회의원 이미지, seq_id 업데이트: #{e.message}")
      end
    end

    PoliticalParty.eager_load(:members).all.each do |party|
      party.average_attendance = party.members.calc_average_attendance
      party.save
    end
  end

  private

  def matching_member(name, seq_id)
    # 이름이 한문이거나 동명이인 있으면 상세페이지의 한자로 member find

    members = Member.current.where_ko_or_ch_name(name)
    return members.first if members.size == 1

    document = scrap_member_show_page(seq_id)
    _, ch_name = document.css("#kso-content-wrap .container .row .container .row .panel-body h1").children.text.split(" ")
    party_name = document.css("#kso-content-wrap .container .row .container .row .panel-body .row .col-md-9 table tr:nth-child(1) td:nth-child(2)").children.text.split.last
    region = document.css("#kso-content-wrap .container .row .container .row .panel-body .row .col-md-9 table tr:nth-child(2) td:nth-child(2)").children.text.gsub(" ", "")

    member = Member.current.find_by("response ->> 'HJ_NM' = ? AND response ->> 'POLY_NM' = ? AND response ->> 'ORIG_NM' = ?", ch_name, party_name, region)
  end

  def convert_url_to_image(image_url)
    return nil unless image_url.present?
    uri = URI.parse(image_url)
    image = uri.open

    return image
  end

  def get_content_type(image_url)
    ext_name = File.extname(image_url).delete(".")
    return false unless PERMIT_IMAGE_FORMAT.include?(ext_name)

    "image/#{ext_name}"
  end
end
