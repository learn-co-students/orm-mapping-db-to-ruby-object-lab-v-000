require 'pry' 
class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def self.new_from_db(row)
    new_student = self.new 
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student 
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students 
    SQL
    DB[:conn].execute(sql).each do |row|
      @@all << self.new_from_db(row)
    end 
    @@all 
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
     
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
    
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
  
  def self.all_students_in_grade_9
    sql =  "SELECT *
      FROM students
      WHERE grade = 9"
      student = DB[:conn].execute(sql)
  end
  
  def self.students_below_12th_grade
    sql = "SELECT *
    FROM students
    WHERE grade IS NOT 12"
    student_info = DB[:conn].execute(sql)
    student = self.new_from_db(student_info[0])
    students = []
    students << student 
    return students 
  end
  
  def self.first_X_students_in_grade_10(num)
    sql = "SELECT *
    FROM students
    WHERE grade = 10 
    LIMIT ?"
    DB[:conn].execute(sql, num)
  end
  
  def self.first_student_in_grade_10 
    sql = "SELECT *
    FROM students
    WHERE grade = 10 
    LIMIT 1"
    student_info = DB[:conn].execute(sql)
    student = self.new_from_db(student_info[0])
  end
  
  def self.all_students_in_grade_X(grade)
    sql = "SELECT *
    FROM students
    WHERE grade = ?"
    DB[:conn].execute(sql, grade)
  end 
end
