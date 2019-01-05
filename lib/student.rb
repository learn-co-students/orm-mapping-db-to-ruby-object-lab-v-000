require 'pry' 
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    s = self.new 
    s.id = row[0]
    s.name = row[1]
    s.grade = row[2]
    s
    # create a new Student object given a row from the database
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 9
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade < 12
    SQL
    DB[:conn].execute(sql).map{|student| self.new_from_db(student)}
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    students = DB[:conn].execute(sql)
    students.map{|student| self.new_from_db(student)} 
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10 
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 10 LIMIT 1
    SQL
    self.new_from_db(DB[:conn].execute(sql)[0])
  end
  

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 10 LIMIT ?
    SQL
    DB[:conn].execute(sql, x).map{|student| self.new_from_db(student)}
  end

  def self.find_by_name(name)
    # binding.pry
    # find the student in the database given a name
    sql = <<-SQL
      SELECT * FROM students WHERE students.name = ?
    SQL
    self.new_from_db(DB[:conn].execute(sql, name)[0])
    # return a new instance of the Student class
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
