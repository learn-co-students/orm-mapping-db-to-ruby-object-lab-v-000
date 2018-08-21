class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
    SELECT *
    FROM students
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

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

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL
    array_ninth = DB[:conn].execute(sql)
    array_ninth
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    where grade < 12
    SQL
    array_below_12th = DB[:conn].execute(sql)
    array_below_12th
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT *
    FROM students
    HAVING grade = 10
    LIMIT x.to_int
    SQL
    array_tenth_limit = DB[:conn].execute(sql)
    array_tenth_limit
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT *
    FROM students
    GROUP BY grade
    HAVING grade = x
    SQL
    array_in_grade = DB[:conn].execute(sql)
    array_in_grade
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
