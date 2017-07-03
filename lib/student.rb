require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    Student.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end

  end

  def self.all
    DB[:conn].execute(
      "SELECT * FROM students;"
      ).collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    self.new_from_db(
      DB[:conn].execute("SELECT * FROM students
      WHERE name = (?);", name).flatten
      )
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute(
      "SELECT * FROM students
      WHERE grade = 9;"
      ).collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    DB[:conn].execute(
      "SELECT * FROM students
      WHERE grade < 12;"
      ).collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_x_students_in_grade_10(x)
    DB[:conn].execute(
      "SELECT * FROM students
      WHERE grade = 10
      LIMIT ?;", x
      ).collect do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    DB[:conn].execute(
      "SELECT * FROM students
      WHERE grade = 10
      LIMIT 1;"
      ).collect do |row|
      Student.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_x(grade)
    DB[:conn].execute(
      "SELECT * FROM students
      WHERE grade = ?;", grade
      ).collect do |row|
      Student.new_from_db(row)
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
