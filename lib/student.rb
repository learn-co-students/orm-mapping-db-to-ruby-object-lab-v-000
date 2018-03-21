class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row) #accepts a row from the database as an argument
    new_student = self.new# creates a new 'Student object' given a row from the database
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end


  def self.all # retrieves all the rows from the "Students" database
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row| #value of the hash(call to database) is a new instance of the SQLite3::Database class- .map iterates over each row
      self.new_from_db(row) #creates a new Student object for each row.
    end
  end


  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row| # find and returns a new instance of the Student class given a name.
      self.new_from_db(row)
    end.first # chaining - grabbing the .first element from the returned array
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
      SELECT COUNT(*)
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row| #returns an array of all the students in grade 9.
      self.new_from_db(row)
    end
  end


  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT COUNT(*)
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row| #returns an array of all the students below 12th grade.
      self.new_from_db(row)
    end
  end


  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY id
      LIMIT ?
    SQL

    DB[:conn].execute(sql, num).map do |row| #returns an array of X number of students in grade 10.
      self.new_from_db(row)
    end
  end


  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
    SQL

    DB[:conn].execute(sql).map do |row| #returns the first student that is in grade 10.
      self.new_from_db(row)
    end.first
  end


  def self.all_students_in_grade_X(num) #takes in an argument of grade for which to retrieve the roster
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, num).map do |row| #returns an array of all students for grade X.
      self.new_from_db(row)
    end
  end

end
