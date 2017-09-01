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

  def self.all
   sql = "SELECT * FROM students;"
   students = DB[:conn].execute(sql)
    all = students.collect {|student| self.new_from_db(student)}
    all 
  end# of self.all

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = (?);"
    row = (DB[:conn].execute(sql, name)).flatten 
    self.new_from_db(row)
  end
  
  
  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9;"
    grade_9 = DB[:conn].execute(sql)
    grade_9
  end# of self.count_all_students_in_grade_9
  
  
  def self.students_below_12th_grade
    sql = "SELECT * FROM students GROUP BY grade HAVING grade < 12;"
    nonsenior = DB[:conn].execute(sql)
    nonsenior
  end# of self.students_below_12th_grade
  
  
  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT (?);"
    first_x_in_10 = DB[:conn].execute(sql, x)
    first_x_in_10
  end# of self.first_x_students_in_grade_10
  
  
  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1;"
    first_10th_grader = (DB[:conn].execute(sql)).flatten
    student = self.new_from_db(first_10th_grader)
    student
  end# of self.first_student_in_grade_10
  
  
  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = (?);"
    all_grade_x = DB[:conn].execute(sql, x)
    all_grade_x 
  end# of self.all_students_in_grade_X
  
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
