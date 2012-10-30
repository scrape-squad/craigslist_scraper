require_relative '../lib/search_result.rb'
require 'fakeweb'
require 'sqlite3'

describe Search_Result do
  let(:searchresult) { Search_Result.new }

  before do
    @url = "http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=futon+soma&catAbb=sss"
    FakeWeb.register_uri(:get, @url, :body => IO.read("./spec/dummy.html"))
    searchresult.open_url(@url)
    post_mock = mock "Post"
    Post.stub!(:from_url).and_return(post_mock)
  end

  context "#initialize" do
    it "has a collection of posts" do
      searchresult.posts.should be_an_instance_of Array
    end
  end

  context "#open_url" do
    it "should receive a valid url" do
      searchresult.open_url(@url).should be_an_instance_of Nokogiri::HTML::Document
    end
  end

  context "#parse" do
    it "should find all post description urls" do
      searchresult.parse
      searchresult.posts.size.should eq 100
    end
  end

  context "#search_parameter" do
    it "should find all search parameters" do
      searchresult.search_parameter.should eq "futon soma"
    end
  end

  context "#to_db" do
    let(:db) { SQLite3::Database.new ('test.db') }
    before do
      db.execute <<-SQL
        CREATE TABLE search_results (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          search_parameter VARCHAR(64),
          created_at DATETIME,
          updated_at DATETIME
        )
      SQL
    end
    it "sends search paramter to search results table" do
      searchresult.to_db(db)
      db.get_first_value('SELECT search_parameter FROM search_results').should eq 'futon soma'
    end
  end
end
