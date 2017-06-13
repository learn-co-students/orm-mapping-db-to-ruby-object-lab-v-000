require "pry"
class Student
  attr_accessor :id, :name, :grade

  def initialize
    @id = nil
    @name = nil
    @grade = nil
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    s = Student.new
    s.tap{
      s.id = row[0]
      s.name = row[1]
      s.grade = row[2]
    }
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    rows = DB[:conn].execute("SELECT * FROM students")
    students = []
    students = rows.map {|row| Student.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    Student.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    return DB[:conn].execute("SELECT * FROM students WHERE grade = ?", 9)
  end
  def self.first_x_students_in_grade_10(limit)
    return DB[:conn].execute("SELECT * FROM students WHERE grade = ? LIMIT ?", 10, limit)
  end
  def self.first_student_in_grade_10
    return Student.new_from_db(first_x_students_in_grade_10(1).flatten)
  end
  def self.students_below_12th_grade
    return DB[:conn].execute("SELECT * FROM students WHERE grade != ?", 12)
  end
  def self.all_students_in_grade_x(grade)
    return DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
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
