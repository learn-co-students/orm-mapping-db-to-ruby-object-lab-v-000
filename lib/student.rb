require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student  #return value
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    dbs = DB[:conn].execute(sql)
    dbs.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    student = self.new
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    row = DB[:conn].execute(sql,name).flatten
    self.new_from_db(row)
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
    sql = "SELECT * FROM students WHERE grade = 9"
    dbs = DB[:conn].execute(sql)
    dbs.map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade<12"
    dbs = DB[:conn].execute(sql)
    dbs.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_x_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade=10 LIMIT ?"
    dbs = DB[:conn].execute(sql,x)
    dbs.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    self.first_x_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_x(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    dbs = DB[:conn].execute(sql,x)
    dbs.map do |row|
      self.new_from_db(row)
    end
  end
end
