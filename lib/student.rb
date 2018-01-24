class Student
  attr_accessor :id, :name, :grade
  @@record = []

  def initialize
    @@record << self
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
      SQL

    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      SQL

     self.new_from_db(DB[:conn].execute(sql, name).flatten)
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
    grade = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    grade
  end

  def self.all_students_in_grade_x(grade)
    grade = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", grade)
    grade
  end

  def self.first_x_students_in_grade_10(number)
    grade = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", number)
    grade
  end

  def self.students_below_12th_grade
    grade = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    grade
  end

  def self.first_student_in_grade_10
    name = DB[:conn].execute("SELECT name FROM students WHERE grade = 10 LIMIT 1")
    first = self.find_by_name(name)
    first
  end

#  def self.first_student_in_grade_10
#    first = @@record.detect {|s| s.grade == 10}
#    first
#  end

end
