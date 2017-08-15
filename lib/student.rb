class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    x = self.new()
    x.id = row[0]
    x.name = row[1]
    x.grade = row[2]
    x
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

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql,x).map do |row|
      self.new_from_db(row)
    end
  end

  def self.count_all_students_in_grade_9
    self.all_students_in_grade_x(9)
  end

  def self.first_x_students_in_grade_10(x)
    self.all_students_in_grade_x(10).slice(0,x)
  end

  def self.first_student_in_grade_10
    self.all_students_in_grade_x(10).first
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
