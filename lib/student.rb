require 'pry'
class Student
  attr_accessor :name, :grade, :id
  

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]# create a new Student object given a row from the database
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students 
      SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
     # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    ary = DB[:conn].execute(sql, name) #returns SQL ary
    student = self.new_from_db(ary[0])
    student
  end
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(name)
      FROM students
      WHERE grade = 9
      GROUP BY name
    SQL
    
    DB[:conn].execute(sql)
  end


  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT COUNT(name)
      FROM students
      WHERE grade < 12
      GROUP BY name
    SQL


    DB[:conn].execute(sql)
  end


  def self.first_x_students_in_grade_10(num)
    sql = <<-SQL
      SELECT COUNT(name)
      FROM students
      WHERE grade = 10
      GROUP BY name
      LIMIT ?

    SQL
    
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    ary = DB[:conn].execute(sql)
    student = self.new_from_db(ary[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade)
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
