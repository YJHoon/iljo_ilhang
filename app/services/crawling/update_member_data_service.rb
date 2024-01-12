class Crawling::UpdateMemberDataService < Crawling::BaseService
  PERMIT_IMAGE_FORMAT = %w[png jpg jpeg].freeze

  def initialize
    super

    @member_list ||= get_member_list()
  end

  def update_member_image # 국회의원 이미지 업데이트
    begin
      member_list.each do |data|
        image_url = data.css("a img").first.attribute("src").value
        name = data.css("a h4").first.text.split.last

        is_image = get_content_type(image_url)
        next unless is_image
        temp_image = convert_url_to_image(image_url)

        member = Member.find_by_name(name)
        member.update(image: temp_image) if member.present?
      end
    rescue => e
      ErrorLog.create(msg: "국회의원 이미지 업데이트: #{e.message}")
    end
  end

  def update_member_seq_id
    begin
      member_list.each do |data|
        name = data.css("a h4").first.text.split.last
        match = data.css("a").first["href"].match(/&member_seq=(.*)/)[1]
        id = match ? match[1] : nil

        member = Member.find_by_name(name)
        member.update(seq_id: id) if member.present? && !id.nil?
      end
    rescue => e
      ErrorLog.create(msg: "국회의원 seq id 업데이트: #{e.message}")
    end
  end

  private

  def convert_url_to_image(image_url)
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
