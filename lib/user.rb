require 'sqlite3'

class User
  attr_accessor :email, :password
  def initialize(email, password)
    @email     = email
    @password  = password
  end

  def create_user(db)
    sql = "INSERT INTO users(email, password, created_at, updated_at) "\
          "VALUES('#{@email}', '#{@password}', DATETIME('now'), DATETIME('now'))"
    db.execute sql
  end

  def existing_user?(db, email) # has not been incorporated
    query = "SELECT email from users "\
            "WHERE email = '#{email}'"
    existing_user = db.get_first_value(query)
    email == existing_user ? true : false
  end

  def authenticate?(db, email, password) # has not been incorporated
    query = "SELECT password from users "\
              "WHERE email = '#{email}'"
    authentication_password = db.get_first_value(query)
    password == authentication_password ? true : false
  end
end