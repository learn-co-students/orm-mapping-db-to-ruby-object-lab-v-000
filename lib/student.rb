require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL
    student_array = []
    DB[:conn].execute(sql).each do |student|
      puts student
      student_object = Student.new_from_db(student)
      student_array << student_object
    end
    student_array
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    puts name
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    student_from_db = DB[:conn].execute(sql, name)[0]
    student_object = Student.new_from_db(student_from_db)
    student_object
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students where grade = 9
    SQL
    student_array = []
    student_from_db = DB[:conn].execute(sql)
    student_from_db.each do |student|
      student_object = Student.new_from_db(student_from_db)
      student_array << student_object
    end
    student_array
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students where grade < 12
    SQL
    student_from_db = DB[:conn].execute(sql)
    student_array = []
    student_from_db.each do |student|
      student_object = Student.new_from_db(student_from_db)
      student_array << student_object
    end
    student_array
  end

  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
      SELECT * FROM students LIMIT ?
    SQL
    student_array = []
    DB[:conn].execute(sql, limit).each do |student|
      student_object = Student.new_from_db(student)
      student_array << student_object
    end
    student_array
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    student_array = []
    student_object = Student.new_from_db(DB[:conn].execute(sql)[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    student_array = []
    DB[:conn].execute(sql, grade).each do |student|
      student_object = Student.new_from_db(student)
      student_array << student_object
    end
    student_array
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
