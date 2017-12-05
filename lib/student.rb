require 'pry'

class Student
  attr_accessor :id, :name, :grade

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
    all_students = DB[:conn].execute(sql).collect do |row|
      self.create_student_from_row(row)
    end
    all_students
  end

  def self.create_student_from_row(row)
    student = self.new
    student.id, student.name, student.grade = row[0], row[1], row[2]
    student
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    all_students = DB[:conn].execute(sql,num).collect do |row|
      self.create_student_from_row(row)
    end
    all_students
  end

  def self.first_student_in_grade_10
    student = self.first_X_students_in_grade_10(1)[0]
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    result = DB[:conn].execute(sql, name).flatten
    student = self.new
    student.id, student.name, student.grade = result[0], result[1], result[2]
    student
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, grade)
  end

  def self.count_all_students_in_grade_9
    self.all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < ?
    SQL
    DB[:conn].execute(sql, 12)
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
end
