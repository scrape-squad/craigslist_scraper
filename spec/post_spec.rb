require '../lib/post.rb'
require 'fakeweb'
require 'sqlite3'

describe 'Post' do

  subject { Post.new(Time.utc(2012, 1, 1), "Newly Remodled Condo near Tully and Mclaughlin", 2395.30,
    "San Francisco", "apts/housing for rent", "http://sfbay.craigslist.org/search/apa?query=condo&srchType=A&minAsk=&maxAsk=&bedrooms=",
    "This is an awesome place to live!") }

  context '#date' do
    it "should have a date" do
      subject.date.should eq Time.utc(2012, 1, 1)
    end
  end

  context '#title' do
    it "should have a title" do
      subject.title.should eq "Newly Remodled Condo near Tully and Mclaughlin"
    end
  end

  context '#price' do
    it "should have a price" do
      subject.price.should eq 2395.30
    end
  end

  context '#location' do
    it "should have a location" do
      subject.location.should eq "San Francisco"
    end
  end

  context '#category' do
    it "should have a category" do
      subject.category.should eq "apts/housing for rent"
    end
  end

  context '#unique_url' do
    it "should have a url" do
      subject.url.should eq "http://sfbay.craigslist.org/search/apa?query=condo&srchType=A&minAsk=&maxAsk=&bedrooms="
    end
  end

  context '#description' do
    it "should have a description" do
      subject.description.should eq "This is an awesome place to live!"
    end
  end

  context '#new' do
    it "should accept 7 parameters" do
      Post.instance_method(:initialize).arity.should eq 7
    end
  end

  context '.from_url' do
    before(:each) do
      FakeWeb.register_uri(:get, "http://sfbay.craigslist.org/sfc/apa/3373550338.html", :body => IO.read("test_page.html"))
      @post = Post.from_url("http://sfbay.craigslist.org/sfc/apa/3373550338.html")
    end

    let(:post) { @post }
    it "should create a Post from uri" do
      post.should be_an_instance_of Post
    end

    it "creates a post with a date" do
      post.date.should eq Time.utc(2012, 10, 29, 3, 55)
    end

    it "creates a post with a title" do
      post.title.should match "Beautiful fully detached single family home"
    end

    it "creates a post with a price" do
      post.price.should eq 4300
    end

    it "creates a post with a location" do
      post.location.should match "ingleside / SFSU / CCSF"
    end

    it "creates a post with a category" do
      post.category.should match "apts/housing for rent"
    end

    it "creates a post with a url" do
      post.url.should match "http://sfbay.craigslist.org/sfc/apa/3373550338.html"
    end

    it "creates a post with a description" do
      post.description.should match "Gas range and hood"
    end

  context '#to_db' do
    before(:each) {
      @db = SQLite3::Database.new "dummy.db"
      @db.execute <<-SQL
      create table posts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date DATETIME,
          title varchar(64),
          price INTEGER,
          location varchar(30),
          category varchar(30),
          url varchar(64),
          description varchar(30),
          search_result_id INTEGER,
          emailed_at DATETIME
        );
          SQL
    }

    after(:each) {
        File.unlink('dummy.db') if File.exist?('dummy.db')
    }

    it "is sent to the database" do
      subject.to_db(@db, 4)
      @db.execute("SELECT count(*) FROM posts").should eq [[1]]
    end
  end
  end
end