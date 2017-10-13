require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
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

    result = DB[:conn].execute(sql)
    result.map do |res|
      self.new_from_db(res)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT id, name, grade FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    result = DB[:conn].execute(sql, name).flatten
    self.new_from_db(result)
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
      SELECT COUNT(*) FROM students
      WHERE grade = ?
    SQL

    result = DB[:conn].execute(sql, 9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade <= ?
    SQL

    result = DB[:conn].execute(sql, 11)
  end

  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT ?
    SQL

    result = DB[:conn].execute(sql, 10, number)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT 1
    SQL

    result = DB[:conn].execute(sql, 10).flatten
    self.new_from_db(result)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end
end
