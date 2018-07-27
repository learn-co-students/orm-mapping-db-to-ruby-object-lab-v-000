require 'pry'
class Student
  attr_accessor :id, :name, :grade
  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    # student.id
    student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM songs
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    list = []
    DB[:conn].execute(sql, 9).map do |row|
      list << row
    end
    list
  end
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    list = []
    DB[:conn].execute(sql, grade).map do |row|
      list << row
    end
    list
  end
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < ?
    SQL

    list = []
    DB[:conn].execute(sql, 12).map do |row|
      i = self.new_from_db(row)
      list << i
    end
    list
  end
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    list = []
    DB[:conn].execute(sql).map do |row|
      i = self.new_from_db(row)
      list << i
    end
    list
  end
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end
  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      LIMIT ?
    SQL

    list = []
    DB[:conn].execute(sql, 10, limit).map do |row|
      i = self.new_from_db(row)
      list << i
    end
    list
  end
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      LIMIT ?
    SQL

    list = []
    DB[:conn].execute(sql, 10, 1).map do |row|
      i = self.new_from_db(row)
    end.first
  end
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
