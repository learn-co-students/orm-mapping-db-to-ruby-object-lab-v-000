require "pry"
class Student
  attr_accessor :id, :name, :grade

  def set_attributes (id, name, grade)
    @id, @name, @grade = id, name, grade
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new()
    new_student.set_attributes(row[0],row[1],row[2])
    new_student
  end

  def self.all
    all = []
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      SQL
    DB[:conn].execute(sql).each { | row | all.push(self.new_from_db(row))}
    all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name=?
      SQL
    row = DB[:conn].execute(sql,name).first
    self.new_from_db(row)
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
    self.all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * from students
      WHERE grade<12
      SQL
    DB[:conn].execute(sql).map { | row | self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10 (n)
    sql = <<-SQL
      SELECT * from students
      WHERE grade=10
      LIMIT ?
      SQL
    DB[:conn].execute(sql,n).map { | row | self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * from students
      WHERE grade=10
      LIMIT 1
      SQL
    row = DB[:conn].execute(sql).first
    self.new_from_db(row)
  end

  def self.all_students_in_grade_X (grade)
    sql = <<-SQL
      SELECT * from students
      WHERE grade=?
      SQL
    DB[:conn].execute(sql,grade).map { | row | self.new_from_db(row)}
  end
end
