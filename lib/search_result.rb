require 'nokogiri'
require 'open-uri'
require 'uri'
require_relative './post.rb'

class SearchResult
  attr_reader :posts
  def initialize
    @posts = []
  end

  def open_url(url)
    @url = url
    @search_page = Nokogiri::HTML(open(@url))
  end

  def parse
    @search_page.css(".row").each { |post| @posts << Post.from_url(post.at_css("a")[:href]) }
    @posts
  end

  def search_parameter
    uri = URI.parse(@url)
    uri.query.split("&").map do |element|
      if element =~ /query[=](.*)/
        @query = $1
        return @query.split("+") #should this be array or string?
      end
    end
  end

  # def to_db
  #   @db.execute <<-SQL
  #     INSERT INTO search_results
  #     VALUES ("#{@}")

  #   SQL
  # end

  private
  def search_to_post_db
    @posts.each { |post| post.to_db }
  end
end