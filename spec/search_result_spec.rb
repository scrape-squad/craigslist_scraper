require_relative '../lib/search_result.rb'
require 'fakeweb'

describe SearchResult do
  let(:searchresult) { SearchResult.new }

  before do
    @url = "http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=futon&catAbb=sss"
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
      searchresult.search_parameter.should eq "futon"
    end
  end
end
