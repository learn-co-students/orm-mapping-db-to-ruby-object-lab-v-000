class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = ("SELECT * FROM students WHERE name = ? LIMIT 1")

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
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
    sql = "SELECT * FROM students WHERE grade = 9"

    students_9 = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    students_under_12 = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
  end

  def self.first_x_students_in_grade_10(number)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    students_x10 = DB[:conn].execute(sql, number)
  end

  def self.first_student_in_grade_10
    students_x10 = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")
    self.new_from_db(students_x10[0])
  end

  def self.all_students_in_grade_x(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    students_in_grade_x = DB[:conn].execute(sql, grade)
  end

end
