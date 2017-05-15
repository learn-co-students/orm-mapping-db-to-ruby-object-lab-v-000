class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT count(*) FROM students WHERE grade = 9")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
  end

  def self.first_x_students_in_grade_10(num)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?",num)
  end

  def self.first_student_in_grade_10
    first_grade_10 = DB[:conn].get_first_row("SELECT * FROM students WHERE grade = 10")
    self.new_from_db(first_grade_10)
  end

  def self.all_students_in_grade_x(grade_num)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?",grade_num)
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
