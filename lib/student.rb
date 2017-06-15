require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
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

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    row = DB[:conn].execute(sql,name).flatten
    self.new_from_db(row)
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    all_students = DB[:conn].execute(sql)
    all_students.map {|student|
      self.new_from_db(student)
    }
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade == 9
    SQL
    DB[:conn].execute(sql).map {|student|
      self.new_from_db(student)
    }
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    DB[:conn].execute(sql).map {|student|
      self.new_from_db(student)
    }
  end

  def self.first_x_students_in_grade_10(select_count)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade == 10
    SQL
    student_array = DB[:conn].execute(sql).map {|student|
      self.new_from_db(student)
    }
    student_array[0,select_count]
  end

  def self.first_student_in_grade_10
    self.first_x_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade == grade
    SQL
    DB[:conn].execute(sql).map {|student|
      self.new_from_db(student)
    }
  end

end
