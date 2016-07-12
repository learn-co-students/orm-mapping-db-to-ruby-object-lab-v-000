require_relative '../config/environment'
require 'pry'

DB[:conn] = SQLite3::Database.new ":memory:"
