require '../lib/db.rb'
require 'sqlite3'

describe DB do
  context "#initialize" do
    it "should accept 1 arguments" do
      DB.instance_method(:initialize).arity.should eq 1
    end
    it "creates a database" do
      DB.new("test.db")
      File.exist?("test.db").should eq true
    end

    after(:each) do
      File.unlink('test.db') if File.exist?('test.db')
    end
  end

  context "#creates a table" do
    before(:each) do
      File.open('fake.txt', 'w+') do |f|
        f.puts "create table fake (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name varchar(64),
          party varchar(30),
          location varchar(30)
        );"
      end

      @db_stub = SQLite3::Database.new "dummy.db"
      SQLite3::Database.stub!(:new) { @db_stub }

      @db = DB.new('fake.db')
      @db.create_table('fake.txt')
    end

    after(:each) do
      File.unlink('fake.txt') if File.exist?('fake.txt')
      File.unlink('dummy.db') if File.exist?('dummy.db')
    end

    it "creates a table" do
      expect {
        @db_stub.execute("SELECT * FROM fake;")
      }.to_not raise_error
    end

    it "creates a field" do
      expect {
        @db_stub.execute("SELECT name FROM fake")
      }.to_not raise_error
    end
  end
end