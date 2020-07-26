require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student_class = self.new
    student_class.id = row[0]
    student_class.name = row[1]
    student_class.grade = row[2]
    student_class
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    rows = DB[:conn].execute(sql)
    rows.map{|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name).flatten
    student_found = self.new_from_db(row)
    puts "student found: "+student_found.name
    student_found
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
    sql = "SELECT count(name) FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end
  def self.students_below_12th_grade
    sql = "SELECT count(name) FROM students WHERE grade < 12"
    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    student = DB[:conn].execute(sql)[0]
    self.new_from_db(student)
  end

  def self.all_from_db
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql)
  end




end
