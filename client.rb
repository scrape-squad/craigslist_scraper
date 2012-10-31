require './lib/search_result.rb'
require './lib/db.rb'
require './lib/mail.rb'

db = DB.new("craigslist_scraper.db")
db.create_table("./lib/post_schema.txt")
db.create_table("./lib/search_result_schema.txt")

search_result = SearchResult.new()
search_result.open_url("http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=kittens&catAbb=sss")
search_result.parse
search_result.to_db(db.db)

Mail.send_complex_message('mackmcconnell@gmail.com', db.db)

