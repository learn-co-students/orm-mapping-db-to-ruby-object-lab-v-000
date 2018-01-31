require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    Student.new.tap do |student|
      student.name = row[1]
      student.grade = row[2]
      student.id = row[0]
    end
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |el|
      self.new_from_db(el)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL

    x = DB[:conn].execute(sql, name).flatten
    self.new_from_db(x)
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
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    x = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id ASC LIMIT 1").flatten
    self.new_from_db(x)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x)
  end
end
