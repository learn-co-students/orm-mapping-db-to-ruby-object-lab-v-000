require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
# binding.pry
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map{|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
          SELECT * FROM students
          WHERE name = ?
          SQL
    self.new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
          SELECT * FROM students
          WHERE grade = 9
          SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
          SELECT * FROM students
          WHERE grade < 12
          SQL

    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    self.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")[0])    
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
