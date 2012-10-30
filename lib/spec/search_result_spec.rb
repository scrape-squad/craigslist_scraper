require_relative '../search_result.rb'
require 'fakeweb'

describe SearchResult do
  let(:searchresult) { SearchResult.new }
  context "#initialize" do
    it "has a collection of posts" do
      searchresult.posts.should be_an_instance_of Array
    end
  end

  context "#open_url" do
    it "should receive a valid url" do
      url = "http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=futon&catAbb=sss"
      FakeWeb.register_uri(:get, url, :body => IO.read("dummy.html"))
      searchresult.open_url(url).should be_an_instance_of Nokogiri::HTML::Document
    end
  end

  context "#parse" do
    before do
      url = "http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=futon&catAbb=sss"
      FakeWeb.register_uri(:get, url, :body => IO.read("dummy.html"))
      searchresult.open_url(url)
    end

    it "creates Post objects from the description url" do
      post_mock = mock "Post"
      Post.stub!(:from_url).and_return(post_mock)
    end

    it "should find all post description urls" do
      searchresult.parse
      searchresult.posts.size.should eq 100
    end
  end
end