require './lib/search_result.rb'
require './lib/db.rb'


db = DB.new("craiglist_scraper.db")

# create tables if they don't exist already
table = db.db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='posts';")
if table.empty?
  db.create_table("./lib/post_schema.txt")
end
table = db.db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='search_results';")
if table.empty?
  db.create_table("./lib/search_result_schema.txt")
end

# unless File.exist?("craiglist_scraper.db")
#   db = DB.new("craiglist_scraper.db")
#   db.create_table("./lib/post_schema.txt")
#   db.create_table("./lib/search_result_schema.txt")
# end

search_result = SearchResult.new
search_result.open_url("http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=kittens&catAbb=sss")
search_result.parse
search_result.to_db(db.db)

