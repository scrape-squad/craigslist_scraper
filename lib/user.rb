require 'sqlite3'

class User
  attr_accessor :email, :password
  def initialize(email, password)
    @email     = email
    @password  = password
  end

  def create_user(db)
    db.execute("INSERT into users(email, password, created_at, updated_at)
                VALUES(?, ?, DATETIME('now'), DATETIME('now'))",
                @email, @password)
  end

  def existing_user?(db, email)
    query = <<-SQL
      SELECT email from users
      WHERE email = "#{email}"
    SQL
    existing_user = db.get_first_value(query)
    email == existing_user ? true : false
  end

  def authenticate?(db, email, password)
    query = <<-SQL
      SELECT password from users
      WHERE email = "#{email}"
    SQL
    authentication_password = db.get_first_value(query)
    password == authentication_password ? true : false
  end
end