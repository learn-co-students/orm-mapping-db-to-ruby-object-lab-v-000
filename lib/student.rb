require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new.tap do|s|
      s.id = row[0]
      s.name = row[1]
      s.grade= row[2]
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * from students"
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql= <<-SQL
      SELECT * FROM students WHERE name = ?
      LIMIT 1
      SQL
    student_row = DB[:conn].execute(sql, name).flatten
    #binding.pry
    self.new_from_db(student_row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.count_all_students_in_grade_9
  #  ninth = self.all.select{|student| student.grade == 9}.length
    sql = <<-SQL
       SELECT * FROM students WHERE grade = 9
    SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end

  #  binding.pry
  #  ninth
  end

  def self.students_below_12th_grade
    self.all.select{|student| student.grade < 12 }
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students ORDER by students.id LIMIT ?"
    DB[:conn].execute(sql,x).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY students.id LIMIT 1"
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql,x).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
