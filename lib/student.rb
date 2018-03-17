class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    students = DB[:conn].execute("select * from students")
    students.map{ |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    student = DB[:conn].execute("select * from students where name=?", name)
    student.map{ |row| self.new_from_db(row) }.first
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
    sql = "select * from students where grade='9'"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "select * from students where grade < 12"
    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(x)
    sql = "select * from students where grade='10' limit ?"
    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = "select * from students where grade='10' order by id"
    student = DB[:conn].execute(sql)
    student.map{ |row| self.new_from_db(row) }.first
  end

  def self.all_students_in_grade_X(x)
    sql = "select * from students where grade=?"
    DB[:conn].execute(sql, x)
  end

end
