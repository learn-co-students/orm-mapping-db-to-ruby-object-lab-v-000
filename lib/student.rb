require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def initialize(name=nil,grade=nil)
    self.name = name
    self.grade = grade
  end

  def self.new_from_db(row)
    new_student = self.new(row[1],row[2])
    new_student.id = row[0]
    new_student
  end

  def self.all
    student_info_array = DB[:conn].execute("SELECT * FROM students")
    student_info_array.collect {|student_info| self.new_from_db(student_info)}
  end

  def self.find_by_name(name)
    student_info = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1",name)
    self.new_from_db(student_info[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
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
    DB[:conn].execute("SELECT COUNT(*) FROM students WHERE grade = \"9\"")
  end

  def self.students_below_12th_grade
    student_info_array = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    student_info_array.collect {|student_info| self.new_from_db(student_info)}
  end

  def self.first_x_students_in_grade_10(num)
    student_info_array = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id ASC LIMIT ?",num)
    student_info_array.collect {|student_info| self.new_from_db(student_info)}
  end

  def self.first_student_in_grade_10
    student_info = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id ASC LIMIT 1")
    self.new_from_db(student_info[0])
  end

  def self.all_students_in_grade_x(grade)
    student_info_array = DB[:conn].execute("SELECT * FROM students WHERE grade = ?",grade)
    student_info_array.collect {|student_info| self.new_from_db(student_info)}
  end

end
