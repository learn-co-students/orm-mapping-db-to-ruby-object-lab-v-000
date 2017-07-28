require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id, student.name, student.grade = row
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    all = []
    data = DB[:conn].execute("SELECT * FROM students")
    data.each do |row|
      all.push(self.new_from_db(row))
    end
    all
  end

  def self.first_x_students_in_grade_10(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x)
  end

  def self.first_student_in_grade_10
    self.new_from_db(self.first_x_students_in_grade_10(1)[0])
  end

  def self.all_students_in_grade_X
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10")
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    student_data = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)
    self.new_from_db(student_data[0])
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
