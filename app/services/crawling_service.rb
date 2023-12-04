class CrawlingService
  PERMIT_IMAGE_FORMAT = %w[png jpg jpeg].freeze

  def initialize
    @crawling = nil
    @page_num = 1
  end

  def page_scrapping
    loop do
      scrap_url = "https://watch.peoplepower21.org/?mid=AssemblyMembers&mode=search&party=&region=&sangim=&gender=&elect_num=&page=#{@page_num}#watch"
      response = HTTParty.get(scrap_url)
      document = Nokogiri::HTML(response.body)
      member_list = document.css("div#content div.col-md-2")
      break if member_list.size.zero?

      update_member_image(member_list)
      @page_num += 1
    end
  end

  private

  def update_member_image(member_list)
    member_list.each do |data|
      image_url = data.css("a img").first.attribute("src").value
      name = data.css("a h4").first.text.split.last

      is_image = get_content_type(image_url)
      next unless is_image
      temp_image = convert_url_to_image(image_url)

      member = Member.find_by_name(name)
      member.update(image: temp_image) if member.present?
    end
  end

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
