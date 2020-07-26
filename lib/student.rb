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
    rows = DB[:conn].execute("SELECT * FROM students;")

    students = rows.collect{ |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    student_found = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1;", name).flatten
    student = Student.new_from_db(student_found)
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
    DB[:conn].execute("SELECT COUNT(name) FROM students WHERE grade = 9;").flatten
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT COUNT(id) FROM students WHERE grade <= 12;").flatten
  end

  def self.first_student_in_grade_10
    student_info = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1;").flatten

    first_student = Student.new_from_db(student_info)
  end

end
