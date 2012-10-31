require 'multimap'
require 'restclient'
require 'sqlite3'


class Mail


  def self.send_complex_message(db, email)
    links_array = find_links(db)
    links_string = links_to_string(links_array, db)
    data = Multimap.new
    data[:from] = "Tom <user@scrapesquad.mailgun.org>"
    data[:to] = "#{email}"

    data[:subject] = "Hey there! Message from Scrape Squad for you!"

    data[:html] = "<html><h1>Sup chump!</h1><h2>Here is your daily Craigslist search digest.<h2><br>You searched for the following query(ies):<br>#{db.execute("SELECT search_parameter FROM search_results").flatten!.to_s[2..-3]}, #{db.execute("SELECT search_result_url FROM search_results").flatten!.to_s[2..-3]}.<br><br>Alright... here are the latest postings as of #{db.execute("SELECT created_at FROM search_results").flatten!.to_s[2..11]} at #{db.execute("SELECT created_at FROM search_results").flatten!.to_s[13..-6]}:<br> #{links_string}</html>"

    RestClient.post "https://api:key-63ot5dnjyqr63xq-e0s-s-eyai1h89i1"\
    "@api.mailgun.net/v2/scrapesquad.mailgun.org/messages",data

    self.to_db(db, email)
  end

  def self.find_links(db)
    db.execute("SELECT title, price, url FROM posts WHERE emailed_at IS NULL")
  end

  def self.links_to_string(array, db)
    links = ""
    array.each do |link|
      links << "<a href=#{link[2]}>#{link[0]}</a> #{link[1]}<br>"
    end
    links
  end

  def self.to_db(db, email)
    user_id = db.get_first_value("SELECT id FROM users WHERE email = #{email}")
    db.execute("INSERT INTO emails(user_id, created_at)
      VALUES(?, ?)",
      user_id, DateTime.now)
  end


end
