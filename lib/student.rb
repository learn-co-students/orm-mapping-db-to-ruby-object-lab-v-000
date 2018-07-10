require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def initialize
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    rows = DB[:conn].execute(sql)
    rows.collect {|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    rows = DB[:conn].execute(sql, x)
    rows.collect {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    rows = DB[:conn].execute(sql, grade)
    rows.collect {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*)
      FROM students
      WHERE grade = 9
    SQL

    count = DB[:conn].execute(sql)
    return count
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade <= 11
    SQL

    student_rows = DB[:conn].execute(sql)
    student_rows.collect {|row| self.new_from_db(row)}
  end
end
