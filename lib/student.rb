#####attributes
#has an id, name, grade
#####.create_table
#creates a student table
#####.drop_table
#drops the student table
#save
#saves an instance of the Student class to the database
#####.new_from_db
#creates an instance with corresponding attribute values
#retrieving data from the db
#####.find_by_name
#returns an instance of student that matches the name from the DB
#####.count_all_students_in_grade_9
#returns an array of all students in grades 9
#####.students_below_12th_grade
#returns an array of all students in grades 11 or below
#####.all
#returns all student instances from the db
#####.first_x_students_in_grade_10
#returns an array of the first X students in grade 10
#####.first_student_in_grade_10
#returns the first student in grade 10
#####.all_students_in_grade_x                                                                                                                                                                                       
#returns an array of all students in a given grade X

class Student
  attr_accessor :id, :name, :grade

  # create a new Student object given a row from the database
  def self.new_from_db(row)
    s = self.new
    s.id = row[0]
    s.name = row[1]
    s.grade = row[2]
    s
  end

  # retrieve all the rows from the "Students" database
  # remember each row should be a new instance of the Student class
  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # find the student in the database given a name
  # return a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    self.new_from_db(DB[:conn].execute(sql, name).flatten)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
    SQL

    DB[:conn].execute(sql).flatten.take(x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
    self.new_from_db(DB[:conn].execute(sql).flatten)
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade)
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
