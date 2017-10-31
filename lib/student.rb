require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
   
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT * 
      FROM students
    SQL
    # remember each row should be a new instance of the Student class
    found = DB[:conn].execute(sql)
    found.map{|s|self.new_from_db(s) }
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end
  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE grade < 12
    SQL
    DB[:conn].execute(sql)  
  end
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade = 10 
      LIMIT (?)
    SQL
   
    found_x_students = DB[:conn].execute(sql, x)
    found_x_students
  end  
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE grade = ? 
  SQL
 
   DB[:conn].execute(sql, grade)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade = 10 
      ORDER BY id 
      LIMIT 1 
    SQL
   
    found_first_student = DB[:conn].execute(sql)[0]
    self.new_from_db(found_first_student)
    
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE name = (?)
    SQL
    # return a new instance of the Student class
    found_name = DB[:conn].execute(sql, name)
    found_name = found_name[0]
    self.new_from_db(found_name)
   
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
