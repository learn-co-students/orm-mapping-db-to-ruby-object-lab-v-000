require 'pry'

class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def initialize
    @@all << self
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
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).flatten
    new_from_db(row)
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
      SELECT * FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL

    DB[:conn].execute(sql)
  end

  def self.all
    @@all.clear
    students = DB[:conn].execute("SELECT * FROM students;")
    students.each { |row| new_from_db(row) }
    @@all
  end

  def self.first_x_students_in_grade_10(num)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY id
    LIMIT ?
    SQL

    rows = DB[:conn].execute(sql, num)
    students = []
    rows.each { |row| students << new_from_db(row) }
    students
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY id
    LIMIT 1
    SQL

    row = DB[:conn].execute(sql).flatten
    new_from_db(row)
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    rows = DB[:conn].execute(sql, grade)
    students = []
    rows.each { |row| students << new_from_db(row) }
  end
end
