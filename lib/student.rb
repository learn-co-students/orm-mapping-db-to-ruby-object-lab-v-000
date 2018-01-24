require "pry"
class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_stu = Student.new
    new_stu.id = row[0]
    new_stu.name = row[1]
    new_stu.grade = row[2]
    new_stu
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql).each { |row| self.new_from_db(row) }
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql).each { |row| self.new_from_db(row) }
  end


  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
    row = DB[:conn].execute(sql)[0]
    new_from_db(row)
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x)
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
