class Student
  attr_accessor :id, :name, :grade

  # retrieve all the rows from the "Students" database
  # remember each row should be a new instance of the Student class
  def self.all
    sql = "SELECT * FROM students"
    rows = DB[:conn].execute(sql)
    rows.collect { |row| self.new_from_db(row) }
  end

  def self.all_students_in_grade_x(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    rows = DB[:conn].execute(sql, x)
    rows.collect { |row| self.new_from_db(row) }
  end
  
  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
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

  # find the student in the database given a name
  # return a new instance of the Student class
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end
  
  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    row = DB[:conn].execute(sql)[0]
    self.new_from_db(row)
  end
  
  def self.first_x_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    rows = DB[:conn].execute(sql, x)
    rows.collect { |row| self.new_from_db(row) }
  end
  
  # create a new Student object given a row from the database
  def self.new_from_db(row)
    student = self.new
    student.id    = row[0]
    student.name  = row[1]
    student.grade = row[2]
    student
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql)
  end  
end
