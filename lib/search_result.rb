require 'nokogiri'
require 'open-uri'
require_relative './post.rb'

class SearchResult
  attr_reader :posts
  def initialize
    @posts = []
  end

  def open_url(url)
    @search_page = Nokogiri::HTML(open(url))
  end

  def parse
    @search_page.css(".row").each { |post| @posts << Post.from_url(post.at_css("a")[:href]) }
    @posts
  end

  private
  def search_to_post_db
    @posts.each { |post| post.to_db }
  end
end