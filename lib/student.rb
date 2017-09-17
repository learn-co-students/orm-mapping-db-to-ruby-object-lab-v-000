class Student
  attr_accessor :id, :name, :grade

  # This is a class method that accepts a row from the database as an argument. It then creates a new student
  # object based on the information in the row. Remember, our database doesn't store Ruby objects, so we have
  # to manually convert it ourself.
  # create a new Student object given a row from the database
  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  # This is a class method that is very similar to the `.find_by_name` method. You will not need an argument
  # since we are returning everything in the database. Run the SQL to return everything (`*`) from a table.
  # retrieve all the rows from the "Students" database
  # remember each row should be a new instance of the Student class
  def self.all
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # This is a class method that accepts a name of a student. You will first run a SQL query to get the result
  # from the database where the student's name matches the name passed into the argument.
  # Next you will take the result and create a new student instance using the `.new_from_db` method you just
  # created.
  # Again, you will use the `.new_from_db` method to create an student instance for each row that comes back
  # from the database.
  # find the student in the database given a name
  # return a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
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

  # This is a class method that does not need an argument. This method should return an array of all the students
  # in grade 9.
  def self.count_all_students_in_grade_9()
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql)
  end
  # The `.students_below_12th_grade` Method
  # This is a class method that does not need an argument. This method should return an array of all the students
  # below 12th grade.
  def self.students_below_12th_grade()
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql)
  end

  # This is a class method that takes in an argument of the number of students from grade 10 to select. This method
  # should return an array of exactly `X` number of students.
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(sql, x)
  end

  # This is a class method that does not need an argument. This should return the first student that is in grade 10.
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  # The `.all_students_in_grade_X` Method
  # This is a class method that takes in an argument of grade for which to retrieve the roster. This method should
  # return an array of all students for grade `X`.
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x)

  end
end
