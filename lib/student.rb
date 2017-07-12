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
    table = DB[:conn].execute("SELECT * FROM students")
    new_student = []
    table.each do |kid|
      x = Student.new_from_db(kid)
      new_student << x
    end
    new_student
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    finder = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name ).flatten
    x = self.new_from_db(finder)
    x
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
    number = DB[:conn].execute(sql)
    number
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL
    number = DB[:conn].execute(sql)
    number
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL
    number = DB[:conn].execute(sql, x)
    number
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    number = DB[:conn].execute(sql).flatten
    x = self.new_from_db(number)
    x
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    number = DB[:conn].execute(sql, x)
    number
  end

end
