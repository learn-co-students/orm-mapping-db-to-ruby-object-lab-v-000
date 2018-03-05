require 'pry'

class Student
  attr_accessor :id, :name, :grade

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

  def self.all
    sql =
      <<-SQL
        SELECT *
        FROM students
      SQL
    DB[:conn].execute(sql).collect {|row| new_from_db(row)}
  end

  def self.find_by_name(name)
    sql =
      <<-SQL
        SELECT *
        FROM students
        WHERE name = ?
      SQL
    row = DB[:conn].execute(sql, name)[0]
    new_from_db(row)
  end

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.count_all_students_in_grade_9
    sql =
      <<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
      SQL
    rows = DB[:conn].execute(sql, 9)
    rows.collect {|row| new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql =
      <<-SQL
        SELECT *
        FROM students
        WHERE grade < ?
      SQL
    rows = DB[:conn].execute(sql, 12)
    rows.collect {|row| new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql =
      <<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
        LIMIT ?
      SQL
    rows = DB[:conn].execute(sql, 10, x)
    rows.collect {|row| new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql =
      <<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
        LIMIT 1
      SQL
    rows = DB[:conn].execute(sql, 10)
    rows.collect {|row| new_from_db(row)}[0]
  end

  def self.all_students_in_grade_X(x)
    sql =
      <<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
      SQL
    rows = DB[:conn].execute(sql, x)
    rows.collect {|row| new_from_db(row)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

end
