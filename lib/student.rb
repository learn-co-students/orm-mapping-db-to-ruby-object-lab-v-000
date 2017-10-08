require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil, name=nil, grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    Student.new(row[0], row[1], row[2])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL

    info = DB[:conn].execute(sql)
    info.map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * from students
      WHERE name = ?
      SQL

    row = DB[:conn].execute(sql, name)[0]
    Student.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    students_list = DB[:conn].execute(sql)
    students_list.collect{|row| Student.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    students_list = DB[:conn].execute(sql)
    students_list.collect{|row| Student.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT (?)
    SQL

    students_list = DB[:conn].execute(sql, x)
    students_list.collect{|row| Student.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    students_list = DB[:conn].execute(sql)
    Student.new_from_db(students_list[0])
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    students_list = DB[:conn].execute(sql, x)
    students_list.collect{|row| Student.new_from_db(row)}
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

end  # End of Class
