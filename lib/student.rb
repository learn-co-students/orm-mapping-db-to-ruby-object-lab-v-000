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

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    row = DB[:conn].execute("SELECT * FROM students WHERE name = name")
    student = self.new
    student.id = row[0][0]
    student.name = row[0][1]
    student.grade = row[0][2]
    student
  end

  def self.count_all_students_in_grade_9
    students = []
    ninth = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    ninth.each do |s|
      student = self.new
      student.id = ninth[0][0]
      student.name = ninth[0][1]
      student.grade = ninth[0][2]
      students << student
    end
    students
  end

  def self.students_below_12th_grade
    students = []
    all_but_12th = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    all_but_12th.each do |s|
      student = self.new
      student.id = all_but_12th[0][0]
      student.name = all_but_12th[0][1]
      student.grade = all_but_12th[0][2]
      students << student
    end
    students
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    students = []
    all_students = DB[:conn].execute("SELECT * FROM students")
    all_students.each_with_index do |s, i|
      student = self.new
      student.id = all_students[i][0]
      student.name = all_students[i][1]
      student.grade = all_students[i][2]
      students << student
    end
    students
  end

  # def self.first_X_students_in_grade_10(x)
  #   students = []
  #   tenth = DB[:conn].execute("SELECT * FROM students WHERE grade = 10")
  #   tenth.each_with_index do |s, i|
  #     student = self.new
  #     student.id = tenth[i][0]
  #     student.name = tenth[i][1]
  #     student.grade = tenth[i][2]
  #     students << student
  #   end
  #   students
  #   # binding.pry
  #   # students(0..x)
  # end

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
