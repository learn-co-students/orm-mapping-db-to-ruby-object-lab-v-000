require 'pry'
class Student
  attr_accessor :id, :name, :grade 

  @@all = []

  def initialize(name = nil, grade = nil, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = (?)
      SQL
    DB[:conn].execute(sql, name).map do |row|
      Student.new_from_db(row)
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

  def self.all
    sql = <<-SQL
      SELECT * FROM students
      SQL
    all = DB[:conn].execute(sql)
    all.each do |student|
      @@all << Student.new_from_db(student)
    end
    @@all
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1
      SQL
    Student.new_from_db(DB[:conn].execute(sql).first)

  end
end


