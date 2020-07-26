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
    sql = <<-SQL
      SELECT * FROM students
      SQL

    student_arr = []

    DB[:conn].execute(sql).each do |student|
      student_arr << self.new_from_db(student)
    end

    student_arr
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = (?)
      SQL

    DB[:conn].execute(sql, 9).each do |student|
      self.new_from_db(student)
    end

  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < (?)
      SQL

    DB[:conn].execute(sql, 12).each do |student|
      self.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = (?) LIMIT 1
      SQL

    self.new_from_db(DB[:conn].execute(sql, 10).flatten)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = (?) LIMIT 1
      SQL

      self.new_from_db(DB[:conn].execute(sql, name).flatten)
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
