require 'nokogiri'
require 'open-uri'
require 'uri'
require 'sqlite3'
require_relative './post.rb'

class Search_Result
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
    uri.query.split("&").map { |element| @query = $1 if element =~ /query[=](.*)/ }
    @query = @query.split("+").join(" ")
  end

  def to_db(db)
    search_parameter
    db.execute <<-SQL
      INSERT INTO search_results (search_parameter, created_at, updated_at)
      VALUES ("#{@query}", DATETIME('now'), DATETIME('now'))
    SQL
    @search_result_id = db.get_first_value('SELECT id FROM search_results ORDER BY id DESC')
  end

  private
  def search_to_post_db(db)
    @posts.each { |post| post.to_db(db, @search_result_id) }
  end
end