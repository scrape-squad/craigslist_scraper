require 'sqlite3'

class DB

  attr_reader :db

  def initialize(filename)
    @filename = filename
    create_db
  end

  def create_table(filename)
    @db.execute(IO.read(filename));
  end

  private

  def create_db
    @db = SQLite3::Database.new @filename
  end
end


