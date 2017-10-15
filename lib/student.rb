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
    @@all = []

    sql = <<-SQL
            SELECT * FROM students
            SQL

    student = self.new
    student.name = DB[:conn].execute(sql)[0][1]
    student.grade = DB[:conn].execute(sql)[0][2]
    @@all << student

    studient = self.new
    studient.name = DB[:conn].execute(sql)[1][1]
    studient.grade = DB[:conn].execute(sql)[1][2]
    @@all << studient

    @@all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
            SELECT * FROM students
            WHERE name = ?
            SQL
    student = self.new
    student.name = DB[:conn].execute(sql, name)[0][1]
    student
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
            SELECT id FROM students
            WHERE grade = 9
            SQL
    DB[:conn].execute(sql)[0]
  end

  def self.students_below_12th_grade
    sql = <<-SQL
            SELECT id FROM students
            WHERE grade < 12
            SQL
    DB[:conn].execute(sql)[0]
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

  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
                SELECT * FROM students
                WHERE grade = 10
                LIMIT ?
            SQL
    DB[:conn].execute(sql, number)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
                SELECT * FROM students
                WHERE grade = 10
                LIMIT 1
            SQL
    first_student = self.new
    first_student.id = DB[:conn].execute(sql)[0][0]
    first_student.name =DB[:conn].execute(sql)[0][1]
    first_student.grade =DB[:conn].execute(sql)[0][2]
    first_student
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
                SELECT * FROM students
                WHERE grade = ?
            SQL
    DB[:conn].execute(sql,grade)
  end
end
