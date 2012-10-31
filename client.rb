require './lib/search_result.rb'
require './lib/db.rb'
require './lib/mail.rb'
require './lib/user.rb'

db = DB.new("craigslist_scraper.db")

# create tables if they don't exist already
table = db.db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='posts';")
if table.empty?
  db.create_table("./lib/post_schema.txt")
end
table = db.db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='search_results';")
if table.empty?
  db.create_table("./lib/search_result_schema.txt")
end
table = db.db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='emails';")
if table.empty?
  db.create_table("./lib/mail_schema.txt")
end
table = db.db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users';")
if table.empty?
  db.create_table("./lib/user_schema.txt")
end

user = User.new("mackmcconnell@gmail.com", "password")
user.create_user(db.db)

search_result = SearchResult.new
search_result.open_url("http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=kittens&catAbb=sss")
search_result.parse
search_result.to_db(db.db)

Mail.send_complex_message(db.db, "mackmcconnell@gmail.com")
