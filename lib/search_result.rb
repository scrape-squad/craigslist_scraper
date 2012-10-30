require 'nokogiri'
require 'open-uri'

class SearchResult
  attr_reader :posts
  def initialize
    @posts = []
  end

  def open_url(url)
    @search_page = Nokogiri::HTML(open(url))
  end

  def parse
    @search_page.css(".row").each do |post|
      description_url = post.at_css("a")[:href]
      @posts << Post.from_url(description_url)
    end
    @posts
  end
end

class Post
  def self.from_url(des)
  end
end