require_relative "../lib/user.rb"
require 'sqlite3'

describe User do
  let(:user) { User.new('brian@example.com', 'password') }
  context "#initialize" do
    it "requires a user and password" do
      user.email.should eq 'brian@example.com'
      user.password.should eq 'password'
    end
  end

  context "#authenticate" do
    before(:each) do
      @db = SQLite3::Database.new "test2.db"
      @db.execute <<-SQL
      CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email VARCHAR(64),
          password VARCHAR(64),
          created_at DATETIME,
          updated_at DATETIME
      );
      SQL
    end

    after(:each) do
      File.unlink('test2.db') if File.exist?('test2.db')
    end

    it "checks if user exists" do
      user.create_user(@db)
      user.existing_user?(@db, 'brian@example.com').should be_true
      user.existing_user?(@db, 'brian@example2.com').should be_false
    end

    it "authenticates the name and password match" do
      user.create_user(@db)
      user.authenticate?(@db, 'brian@example.com', 'password').should be_true
      user.authenticate?(@db, 'brian@example.com', 'password3').should be_false
    end
  end
end