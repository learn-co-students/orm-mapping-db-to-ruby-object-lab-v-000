require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
            SELECT * FROM students
          SQL
    all = DB[:conn].execute(sql)
    all.collect do |array|
      Student.new.tap do |s|
        s.id = array[0]
        s.name = array[1]
        s.grade = array[2]
      end
    end
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
            SELECT * FROM students
            WHERE grade = 9
          SQL
    grade_9_students = DB[:conn].execute(sql)
    grade_9_students.collect do |array|
      Student.new.tap do |s|
        s.id = array[0]
        s.name = array[1]
        s.grade = array[2]
      end
    end
  end

  def self.students_below_12th_grade
  sql = <<-SQL
          SELECT * FROM students
          WHERE grade = 12
        SQL
    grade_12_students = DB[:conn].execute(sql)
    grade_12_students.collect do |array|
      Student.new.tap do |s|
        s.id = array[0]
        s.name = array[1]
        s.grade = array[2]
      end
    end
  end

  def self.first_student_in_grade_10
  sql = <<-SQL
          SELECT * FROM students
          WHERE grade = 10
          LIMIT 1
        SQL
    grade_10_student = DB[:conn].execute(sql)[0]
    Student.new(
      grade_10_student[0],
      grade_10_student[1],
      grade_10_student[2]
      )
  end

  def initialize(id=nil, name=nil, grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.find_by_name(name)
    sql = <<-SQL
            SELECT * FROM students
            WHERE students.name = name
          SQL
    student_info = DB[:conn].execute(sql)[0]
    Student.new(
      student_info[0],
      student_info[1],
      student_info[2]
    )
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
