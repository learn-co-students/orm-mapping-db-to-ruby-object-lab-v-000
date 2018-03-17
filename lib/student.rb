class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database.
    student = Student.new
    student.name = row[1]
    student.grade = row[2]
    student.id = row[0]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    all_students = DB[:conn].execute(sql)
    all_students.map do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = (?);
    SQL
    row = DB[:conn].execute(sql, name)
    self.new_from_db(row[0])
  end

  def self.count_all_students_in_grade_9
    grade = 9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?;
    SQL
    all_students = DB[:conn].execute(sql, grade)
    all_students.map do |student|
      self.new_from_db(student)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12;
    SQL
    all_students = DB[:conn].execute(sql)
    all_students.map do |student|
      self.new_from_db(student)
    end
  end

  def self.all_students_in_grade_X
    grade = 10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?;
    SQL
    all_students = DB[:conn].execute(sql, grade)
    all_students.map do |student|
      self.new_from_db(student)
    end
  end

  def self.first_x_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?;
    SQL
    first_x_students = DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1;
    SQL
    first_student = DB[:conn].execute(sql)
    self.new_from_db(first_student[0])
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
