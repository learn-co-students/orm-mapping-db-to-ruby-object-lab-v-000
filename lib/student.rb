require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student=Student.new
    student.id=row[0]
    student.name=row[1]
    student.grade=row[2]
    student
    # create a new Student object given a row from the database
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    self.all.find {|student| student.name == name}
  end

  def self.all_students_in_grade_9
    self.all.select {|student| student.grade.to_i==9}
  end

  def self.students_below_12th_grade
    self.all.select {|student| student.grade.to_i<12}
  end

  def self.first_X_students_in_grade_10(x)
    students = self.all.select do |student|
      student.grade.to_i==10
    end
    students[0..x-1]
  end

  def self.first_student_in_grade_10
    students = self.all.find {|student| student.grade.to_i==10}
  end

  def self.all_students_in_grade_X(x)
    self.all.select do |student|
      student.grade.to_i==x
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
