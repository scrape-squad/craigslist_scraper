require 'multimap'
require 'restclient'
require 'sqlite3'


class Mail


  def self.send_complex_message(email, db)
    find_links(db)
    data = Multimap.new
    data[:from] = "Tom <user@scrapesquad.mailgun.org>"
    data[:to] = "#{email}"

    data[:subject] = "Hey there! Message from Scrape Squad for you!"

    data[:html] = "<html><a href='www.google.com'>Google</a></html>"

    RestClient.post "https://api:key-63ot5dnjyqr63xq-e0s-s-eyai1h89i1"\
    "@api.mailgun.net/v2/scrapesquad.mailgun.org/messages",data
  end

  def self.find_links(db)
    puts db.execute("SELECT url FROM posts WHERE emailed_at IS NULL")
  end

end



# Mail.send_complex_message('mackmcconnell@gmail.com', )


# recipient email
#
# text email (links only for now)
#
#
# #email search_result links where emailed_at == NULL
# <a href="www.google.com">Google</a>
#
# @list_of_links.each { |link| puts "<a href=" + #{link}}