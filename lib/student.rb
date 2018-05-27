require 'pry'

class Student
  attr_accessor :id, :name, :grade



  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM
      Students
    SQL

    data = DB[:conn].execute(sql)

    data.map do |item|
      student = self.new_from_db(item)



    end


  end

  def self.find_by_name(student_name)
    # find the student in the database given a name
    # return a new instance of the Student class

    s = Student.new
    s.name = student_name
    s

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

  # def self.find_by_name(name)
  #
  # end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT COUNT(grade) FROM students WHERE grade = "9th"
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT name FROM students WHERE grade BETWEEN "1" AND "11"

    SQL

    DB[:conn].execute(sql).flatten


    # binding.pry
  end

  def self.first_x_students_in_grade_10(number)

    sql = <<-SQL
      SELECT * FROM students ORDER BY grade DESC LIMIT ?
    SQL

    DB[:conn].execute(sql, number)
    # binding.pry
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    first_student = DB[:conn].execute(sql).flatten
    self.new_from_db(first_student)
  end

  def self.all_students_in_grade_x(given_grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql, given_grade)
  end


end
