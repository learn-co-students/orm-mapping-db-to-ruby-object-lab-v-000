require 'pry'

class Student
  attr_accessor :id, :name, :grade

  @@all = []

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
    sql = <<-SQL
      SELECT * FROM students
    SQL

    db_return = DB[:conn].execute(sql)
    db_return.each do |row|
      @@all << Student.new_from_db(row)
    end
    @@all
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 9
    SQL

    db_return = DB[:conn].execute(sql)
    @grade_9_students = []
    db_return.each do |row|
      @grade_9_students << Student.new_from_db(row)
    end
    @grade_9_students
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade < 12
    SQL

    db_return = DB[:conn].execute(sql)
    @below_12th_students = []
    db_return.each do |row|
      @below_12th_students << Student.new_from_db(row)
    end
    @below_12th_students
  end

  def self.first_x_students_in_grade_10(return_count)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 10 LIMIT ?
    SQL

    db_return = DB[:conn].execute(sql,return_count)
    @first_x_10th = []
    db_return.each do |row|
      @first_x_10th << Student.new_from_db(row)
    end
    @first_x_10th
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 10 LIMIT 1
    SQL

    db_return = DB[:conn].execute(sql)
    first_in_10th = Student.new_from_db(db_return[0])
    first_in_10th
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL

    db_return = DB[:conn].execute(sql,grade)
    @students_in_grade = []
    db_return.each do |row|
      @students_in_grade << Student.new_from_db(row)
    end
    @students_in_grade
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE students.name = ? LIMIT 1
    SQL

    db_return = DB[:conn].execute(sql, name)
    found_student = Student.new_from_db(db_return[0]) #db_return[0] is matching DB row
    found_student
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
