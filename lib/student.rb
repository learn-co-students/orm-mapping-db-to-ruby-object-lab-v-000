require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
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

  def self.find_by_name(name)
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE name = ?
        LIMIT 1
      SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

# only returns data, not objects
  def self.all_students_in_grade_9
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
      SQL
      DB[:conn].execute(sql, 9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade < ?
      SQL

      DB[:conn].execute(sql, 12).map do |student_row|
        self.new_from_db(student_row)
      end
  end

# only returns data, not objects
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = 10
        LIMIT ?
      SQL

    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = 10
        LIMIT 1
      SQL
    student_row = DB[:conn].execute(sql)[0]
    Student.new_from_db(student_row)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
      SQL

    students_in_grade_x = DB[:conn].execute(sql, grade)

    students_in_grade_x.map do |student_row|
      Student.new_from_db(student_row)
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
