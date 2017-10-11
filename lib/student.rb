require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
      student = self.new
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
      student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end


  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT #{x}
    SQL

    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = #{x}
    SQL

    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    student_result = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT 1")
    new_from_db(student_result[0])
  end


  def self.count_all_students_in_grade_9
    count = DB[:conn].execute("SELECT COUNT(*) FROM students WHERE students.grade = 9")
    count
  end

  def self.students_below_12th_grade
    below_12 = DB[:conn].execute("SELECT * FROM students WHERE students.grade <= 11")
    below_12
  end

  def self.find_by_name(name)
    student_result = DB[:conn].execute("SELECT * FROM students WHERE students.name = name")
    new_from_db(student_result[0])
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
