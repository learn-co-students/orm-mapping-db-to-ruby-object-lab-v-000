require 'sqlite3'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")} #DB hash that allows you to connect to the database throughout your program.
