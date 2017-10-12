require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
    # create a new Student object given a row from the database
  end

  def self.all
    students = <<-SQL
    SELECT * FROM students;
    SQL

    DB[:conn].execute(students).collect do |row|
      self.new_from_db(row)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    students = <<-SQL
    SELECT * FROM students
    WHERE name = ?;
    SQL
    DB[:conn].execute(students, name).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.count_all_students_in_grade_9
    students = <<-SQL
    SELECT COUNT(students.name) FROM students WHERE grade = 9
    SQL

    DB[:conn].execute(students)
  end

  def self.students_below_12th_grade
    students = <<-SQL
    SELECT name FROM students WHERE grade <= 11
    SQL

    DB[:conn].execute(students)
  end

  def self.first_student_in_grade_10
    students = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    DB[:conn].execute(students).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.first_X_students_in_grade_10(x)
    students = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    DB[:conn].execute(students, x)
  end

  def self.all_students_in_grade_X(x)
    students = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(students, x)

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
