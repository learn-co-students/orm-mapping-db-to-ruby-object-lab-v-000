require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = "SELECT * FROM students"
    self.create_students_from_sql(sql)
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    student = DB[:conn].execute(sql, [name]).first
    Student.new_from_db(student)
  end

  def self.create_students_from_sql(sql)
    rows = DB[:conn].execute(sql)
    rows.collect{|row| Student.new_from_db(row)}
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
    sql = "SELECT COUNT(*) FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    self.create_students_from_sql(sql)
  end

  def self.first_X_students_in_grade_10(n)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    rows = DB[:conn].execute(sql, [n.to_i])
    rows.collect{|row| Student.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    student = DB[:conn].execute(sql).first
    Student.new_from_db(student)
  end

  def self.all_students_in_grade_X(n)
    sql = "SELECT * FROM students WHERE grade = ?"
    rows = DB[:conn].execute(sql, [n])
    rows.collect{|row| Student.new_from_db(row)}
  end

end
