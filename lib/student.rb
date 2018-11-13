require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    self.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end 
  end

  def self.all
    sql =<<-SQL
        SELECT * 
        FROM students
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 
  end

  def self.find_by_name(name)
    sql =<<-SQL
        SELECT *
        FROM students
        WHERE students.name = ?
    SQL
    
    self.new_from_db(DB[:conn].execute(sql, name).flatten)
  end
  
  def self.all_students_in_grade_9
    sql =<<-SQL 
        SELECT *
        FROM students 
        WHERE students.grade = 9
    SQL
    
    DB[:conn].execute(sql)
  end 
  
  def self.students_below_12th_grade
    sql =<<-SQL
        SELECT * 
        FROM students 
        WHERE students.grade < 12 
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end 
  end 
  
  def self.first_X_students_in_grade_10(num)
    sql =<<-SQL 
        SELECT * 
        FROM students
        WHERE students.grade = 10
        ORDER BY(students.id)
        LIMIT ?
    SQL
    
    DB[:conn].execute(sql, num)
  end 
  
  def self.first_student_in_grade_10 
    sql =<<-SQL
        SELECT *
        FROM students 
        WHERE students.grade = 10 
        ORDER BY(students.id)
    SQL
    
    self.new_from_db(DB[:conn].execute(sql).first)
  end 
  
  def self.all_students_in_grade_X(num)
    sql =<<-SQL
        SELECT *
        FROM students 
        WHERE students.grade = ?
    SQL
    
    DB[:conn].execute(sql, num).map do |row|
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
end
