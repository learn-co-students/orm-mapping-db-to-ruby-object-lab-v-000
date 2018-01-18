require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2].to_i
    student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).collect {|student_row| self.new_from_db(student_row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).collect {|student_row| self.new_from_db(student_row)}.first
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
      SELECT *
      FROM students
      WHERE grade = "9"
    SQL

    DB[:conn].execute(sql).map {|student_row| self.new_from_db(student_row)}
  end
  # alternative way to solve:
  # def self.count_all_students_in_grade_9
  #  self.all.select {|student| student.grade == 9}
  # end

  def self.students_below_12th_grade
    self.all.select {|student| student.grade < 12}
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = "10"
      LIMIT ?
    SQL

    DB[:conn].execute(sql, x).map {|student_row| self.new_from_db(student_row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = "10"
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map {|first_sophomore_row| self.new_from_db(first_sophomore_row)}.first
  end
  # alternative way to solve:
  # def self.first_student_in_grade_10
  #  self.all.detect {|student| student.grade == 10}
  # end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x).map {|student_row| self.new_from_db(student_row)}
  end

  # alternative way to solve:
  # def self.all_students_in_grade_x(x)
  #  self.all.select {|student| student.grade == x}
  # end
end
