require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def initialize
  end

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    # create a new Student object given a row from the database
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    student_row_array = DB[:conn].execute(sql)
    return_array = []
    counter = 0

    student_row_array.each do |row|
      return_array[counter] = self.new_from_db(row)
      counter += 1
    end

    return_array
    
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    student_row_array = DB[:conn].execute(sql, 9)
    return_array = []
    counter = 0

    student_row_array.each do |row|
      return_array[counter] = self.new_from_db(row)
      counter += 1
    end

    return_array
    
  end

  def self.students_below_12th_grade

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < ?
    SQL

    student_row_array = DB[:conn].execute(sql, 12)
    return_array = []
    counter = 0

    student_row_array.each do |row|
      return_array[counter] = self.new_from_db(row)
      counter += 1
    end

    return_array
    
  end

  def self.first_student_in_grade_10

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      LIMIT 1
    SQL

    student_row = DB[:conn].execute(sql, 10)

    return_student = self.new_from_db(student_row[0])
    return_student
    
  end

  def self.first_x_students_in_grade_10(count)

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      LIMIT ?
    SQL

    student_row_array = DB[:conn].execute(sql, 10, count)
    return_array = []
    counter = 0

    student_row_array.each do |row|
      return_array[counter] = self.new_from_db(row)
      counter += 1
    end

    return_array
    
  end

  def self.all_students_in_grade_x(grade)

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    student_row_array = DB[:conn].execute(sql, grade)
    return_array = []
    counter = 0

    student_row_array.each do |row|
      return_array[counter] = self.new_from_db(row)
      counter += 1
    end

    return_array
    
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE name = ?
    SQL
    student_row = DB[:conn].execute(sql, name)
    return_student = self.new_from_db(student_row[0])
    return_student
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
