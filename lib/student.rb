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
    student_db = DB[:conn].execute("SELECT * FROM students")
    students = []
    student_db.each do |row|
      student = self.new_from_db(row)
      students << student
    end
    students
  end

  def self.find_by_name(name)
    student_row = DB[:conn].execute("SELECT * FROM students WHERE name =?", name).flatten
    # binding.pry
    student = self.new_from_db(student_row)
    student
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
    students_9th = DB[:conn].execute("SELECT COUNT(*) FROM students WHERE grade = 9")
  end

  def self.students_below_12th_grade
    students_12th = DB[:conn].execute("SELECT COUNT(*) FROM students WHERE grade < 12")
  end

  def self.first_x_students_in_grade_10(number_of_students)
    students_10th = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT(?)", number_of_students)
  end

  def self.first_student_in_grade_10
    first_student_10th = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1").flatten
    self.new_from_db(first_student_10th)
  end

  def self.all_students_in_grade_x(grade)
    students_x = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
    # binding.pry
  end
end
