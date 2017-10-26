require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil,name=nil,grade=nil)
    @id= id
    @name=name
    @grade=grade
  end

  def self.new_from_db(row)
    Student.new(row[0],row[1],row[2])
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
      SQL
      all_students=[]
      DB[:conn].execute(sql).each do |student|
        all_students<<Student.new_from_db(student)
      end
      all_students

  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name= ?
      SQL
    DB[:conn].execute(sql, name)
    self.new_from_db(DB[:conn].execute(sql, name)[0])

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

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
      SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
      SQL
    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 ORDER BY name LIMIT ?
      SQL
    DB[:conn].execute(sql,x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
      SQL
    self.new_from_db(DB[:conn].execute(sql)[0])
    
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
      SQL
    DB[:conn].execute(sql,x)
  end
end
