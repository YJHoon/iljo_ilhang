class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def crawling_test
    require "open-uri"

    # Fetch and parse HTML document
    doc = Nokogiri::HTML(URI.open("https://nokogiri.org/tutorials/installing_nokogiri.html"))

    # Search for nodes by css
    doc.css("nav ul.menu li a", "article h2").each do |link|
      puts link.content
    end

    # Search for nodes by xpath
    doc.xpath("//nav//ul//li/a", "//article//h2").each do |link|
      puts link.content
    end

    # Or mix and match
    doc.search("nav ul.menu li a", "//article//h2").each do |link|
      puts link.content
    end

    doc = Nokogiri::HTML(URI.open("https://watch.peoplepower21.org/?mid=Member&member_seq=506#watch"))
    # doc = Nokogiri::HTML(URI.open('https://watch.peoplepower21.org/?act=&mid=AssemblyMembers&vid=&mode=search&name=&party=&region=&sangim=&gender=&age=&elect_num=&singlebutton=#watch'))

    # Or mix and match
    doc.search(".container .row .panel-body .row .col-md-9").each do |link|
      puts link.content
    end
    doc.css(".container .row .panel-body .row .col-md-9").each do |link|
      puts link.content
    end
  end
end
