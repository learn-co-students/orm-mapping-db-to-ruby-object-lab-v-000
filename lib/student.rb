require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student=self.new
    new_student.id, new_student.name,new_student.grade = row[0],row[1],row[2]
    new_student
  end

  def self.all
    sql = "SELECT * FROM students;"
    students=DB[:conn].execute(sql)
    binding.pry
    students.collect{|student_row| self.new_from_db(student_row)}

  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE ? = name
    SQL
    student=DB[:conn].execute(sql,name).flatten
    new_from_db(student)
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
      SELECT count(*) FROM students
      WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT count(*) FROM students
      WHERE grade < 12
    SQL
    DB[:conn].execute(sql)
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
    self.new_from_db(self.first_x_students_in_grade_10(1)[0])
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    DB[:conn].execute(sql, x)
  end
end
