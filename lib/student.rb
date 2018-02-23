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
    all_array = DB[:conn].execute("SELECT * FROM students")
    # each row becomes a new instance of the Student class
    all_array.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # finds the student in the database given a name & returns a new instance of the Student class
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name).flatten
    student = self.new_from_db(row)
    student
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
      SELECT COUNT(grade) FROM students
      WHERE grade = 9;
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12;")
  end

  def self.first_X_students_in_grade_10(num_returned)
    # returns an array of the first X students in grade 10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.id
      LIMIT ?;
    SQL

    DB[:conn].execute(sql, num_returned)
  end

  def self.first_student_in_grade_10
    # returns the first student in grade 10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY students.id LIMIT 1
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    # returns an array of all students in a given grade X
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      ORDER BY students.id
    SQL

    DB[:conn].execute(sql, grade).collect do |row|
      self.new_from_db(row)
    end
  end
end
