require "pry"
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
    sql = <<-SQL
    SELECT [id, name ,grade ] as students;
    SQL
  end

  def self.find_by_name(name)
    sql = <<-SQL
       SELECT * FROM students WHERE name = ?;
    SQL
  
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
  end.first
end
 
 def self.all
   sql = <<-SQL
   SELECT * 
    FROM students 
    SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
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
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 9
    SQL
    
    DB[:conn].execute(sql)
 end
 
  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * 
    FROM students 
    WHERE students.grade < 12
    SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end
   
   def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE students.grade = 10
    LIMIT 1
    SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE students.grade = 10
    LIMIT 1
    SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, x)
  end
  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, x)
  end
  
end
