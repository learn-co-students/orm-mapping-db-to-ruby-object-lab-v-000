require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
        SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map do |x|
      self.new_from_db(x)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL
    DB[:conn].execute(sql,name).map do |x|
      self.new_from_db(x)
    end.last
    # I want to use irb to see what first or last actually is, but not sure what
    # to do once inside the pry
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
     SELECT * FROM students
     WHERE grade = 9;
   SQL
   grade_9_students = []
   grade_9_students<<DB[:conn].execute(sql)[0]
 end

#why does it have to be new_from_db if the object already existed according to the RSPEC
def self.first_student_in_grade_10
  sql = <<-SQL
  SELECT * FROM students
  where grade = 10
  ORDER BY id LIMIT 1
  SQL
  first_student = DB[:conn].execute(sql)
  first_student_object = self.new_from_db(first_student[0])
end

def self.students_below_12th_grade
  sql = <<-SQL
    SELECT * FROM students
    WHERE grade <= 11
  SQL
  under_grade_12 = []
  under_grade_12 << DB[:conn].execute(sql)[0]
end

def self.first_x_students_in_grade_10(num)
  sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    ORDER BY id LIMIT ?
  SQL
  first_x = []
  DB[:conn].execute(sql,num).each do |student|
    first_x << student
  end
end

def self.all_students_in_grade_x(num)
  sql = <<-SQL
  SELECT * FROM students
  WHERE grade = ?
  SQL

  students_in_x = []
  DB[:conn].execute(sql,num).each do |student|
    students_in_x << student
  end
end

end
