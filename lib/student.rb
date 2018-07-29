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
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
    SELECT * FROM students
    SQL
    all_students = DB[:conn].execute(sql)

    all_students.map do |row_student|
      new_student = Student.new
      new_student.name = row_student[1]
      new_student.grade = row_student[2]
      new_student
    end

    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL
    student_row = DB[:conn].execute(sql, name).flatten
    # return a new instance of the Student class
    new_student = Student.new
    new_student.name = student_row[1]
    new_student.grade = student_row[2]
    new_student
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
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT COUNT(grade) FROM students
    WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    below_12_students = DB[:conn].execute(sql)

    below_12_students.map do |row_student|
      new_student = Student.new
      new_student.name = row_student[1]
      new_student.grade = row_student[2]
      new_student
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?
    SQL
    first_x_students = DB[:conn].execute(sql, x)

    first_x_students.map do |row_student|
      new_student = Student.new
      new_student.name = row_student[1]
      new_student.grade = row_student[2]
      new_student
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1
    SQL
    first_student = DB[:conn].execute(sql).flatten

    new_student = Student.new
    new_student.id = first_student[0]
    new_student.name = first_student[1]
    new_student.grade = first_student[2]
    new_student
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    grade_x_students = DB[:conn].execute(sql, x)

    grade_x_students.map do |row_student|
      new_student = Student.new
      new_student.name = row_student[1]
      new_student.grade = row_student[2]
      new_student
    end
  end
end
