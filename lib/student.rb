require 'pry'

class Student
  attr_accessor :id, :name, :grade
  @@all = []

  class << self
    def new_from_db(row)
      student = self.new
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
      
      student
    end
  
    def all
      sql = <<-SQL
        SELECT id, name, grade
        FROM students;
      SQL
      
      students_data = DB[:conn].execute(sql)
      students_data.each do |row|
        @@all << new_from_db(row)
      end
      
      @@all
    end
  
    def find_by_name(name)
      sql = <<-SQL
        SELECT id, name, grade
        FROM students
        WHERE name = ?;
      SQL
      
      student_data = DB[:conn].execute(sql, name).flatten
      
      new_from_db(student_data)
    end
    
    def create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
  
      DB[:conn].execute(sql)
    end
  
    def drop_table
      sql = "DROP TABLE IF EXISTS students"
      DB[:conn].execute(sql)
    end
    
    def count_all_students_in_grade_9
      sql = <<-SQL
        SELECT id, name, grade
        FROM students
        WHERE grade = 9;
      SQL
      
      grade_9_students = DB[:conn].execute(sql)
    end
    
    def students_below_12th_grade
      sql = <<-SQL
        SELECT id, name, grade
        FROM students
        WHERE grade < 12;
      SQL
      
      not_grade_12_students = DB[:conn].execute(sql)   
    end
    
    def first_student_in_grade_10
      sql = <<-SQL
        SELECT id, name, grade
        FROM students
        WHERE grade = 10
        LIMIT 1;
      SQL
      
      student_data = DB[:conn].execute(sql).flatten
      new_from_db(student_data)
    end
  
  
    def first_x_students_in_grade_10(x)
      sql = <<-SQL
          SELECT id, name, grade
          FROM students
          WHERE grade = 10
          LIMIT ?;
        SQL
        
        student_data = DB[:conn].execute(sql, x)
    end
    
    def all_students_in_grade_X
      x = 10
      
      sql = <<-SQL
        SELECT id, name, grade
        FROM students
        WHERE grade = ?;
      SQL
      
      student_data = DB[:conn].execute(sql, x)
    end
    
  end #-----end of Class methods ------#
  

  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
end