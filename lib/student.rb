require 'pry'

@@grade_9 = []
@@grade_10 = []
@@grade_11 = []
@@grade_12 = []
@@all = []


class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    y = Student.new 
    y.id = row[0]
    y.name = row[1]
    y.grade = row[2]
    y 
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    x = DB[:conn].execute(sql)
      x.each do |student| 
        y = Student.new 
        y.id = student[0]
        y.name = student[1]
        y.grade = student[2]
        @@all << y 
      end    
      @@all 
  end 
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    x = DB[:conn].execute(sql, name).flatten 
    
    y = Student.new 
    y.id = x[0]
    y.name = x[1]
    y.grade = x[2]
    y
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
      SELECT * FROM students WHERE grade = ?
    SQL

    x = DB[:conn].execute(sql, 9)
    x.each do |student| 
      y = Student.new 
      y.id = student[0]
      y.name = student[1]
      y.grade = student[2]
      @@grade_9 << y 
      @@grade_9 
    end 
  end 
  
  def self.students_below_12th_grade 
    sql = <<-SQL
      SELECT * FROM students WHERE grade < ?
    SQL

    x = DB[:conn].execute(sql, 12)
      x.each do |student| 
        y = Student.new 
        y.id = student[0]
        y.name = student[1]
        y.grade = student[2]
        @@grade_12 << y 
      end    
      @@grade_12 
  end 
  
  def self.first_X_students_in_grade_10(a) 
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? AND id < ?
    SQL

    x = DB[:conn].execute(sql, 10, a + 1)
     
    x.each do |student| 
      y = Student.new 
      y.id = student[0]
      y.name = student[1]
      y.grade = student[2]
      @@grade_10 << y 
    end 
    
   @@grade_10
  end 
  
  def self.first_student_in_grade_10 
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? GROUP BY id HAVING MIN(id)
    SQL

    x = DB[:conn].execute(sql, 10).flatten 
     
      y = Student.new 
      y.id = x[0]
      y.name = x[1]
      y.grade = x[2]
      y 
  end 
  
  def self.all_students_in_grade_X(a)
    @@all = []
    
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    x = DB[:conn].execute(sql, a)
    x.each do |student| 
      y = Student.new 
      y.id = student[0]
      y.name = student[1]
      y.grade = student[2]
      @@all << y 
    end 
   @@all 
  end 
end
