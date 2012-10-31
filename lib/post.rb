require 'nokogiri'
require 'open-uri'

class Post

  attr_reader :date, :title, :price, :location, :category, :url, :description

  def initialize(date, title, price, location, category, url, description)
    @date = date
    @title = title
    @price = price
    @location = location
    @category = category
    @url = url
    @description = description
  end

  def self.from_url(url) #Need to update to handle deleted posts.
    doc = Nokogiri::HTML(open(url))
    Post.new(date(doc), title(doc), price(doc), location(doc), category(doc), url, description(doc))
  end

  def to_db(db, search_result_id)
    db.execute("insert into posts(date, title, price, location, category, URL,
      description, search_result_id)
      values(?, ?, ?, ?, ?, ?, ?, ?)",
      @date.to_s, @title, @price, @location, @category, @url, @description, search_result_id)
  end


  private
  def self.date(doc)
    date_string = doc.at_css(".postingdate").text
    Time.utc(doc.at_css(".postingdate").text.match(/\d{4}/)[0],
      doc.at_css(".postingdate").text.match(/-\d{2}-/)[0][1..-2],
      doc.at_css(".postingdate").text.match(/-\d{2},/)[0][1..-2],
      doc.at_css(".postingdate").text.match(/\d{1}:/)[0][0..-2],
      doc.at_css(".postingdate").text.match(/:\d{2}/)[0][1..-1])
  end

  def self.title(doc)
    doc.at_css("title").text
  end

  def self.price(doc)
    result = doc.at_css("h2").text.match(/\$\d+/)
    if result.nil?
      return nil
    else
      result[0][1..-1].to_i
    end
  end

  def self.location(doc)
    result = doc.at_css("h2").text.match(/\([^\(]+\)$/)
    if result.nil?
      return nil
    else
      result[0][1..-2]
    end
  end

  def self.category(doc)
    result = doc.css(".bchead a")[-1].text
  end

  def self.description(doc)
    doc.at_css("#userbody").text
  end

end