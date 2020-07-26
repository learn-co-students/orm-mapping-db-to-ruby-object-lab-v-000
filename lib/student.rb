class Student
  attr_accessor :id, :name, :grade

# create a new Student object given a row from the database
  def self.new_from_db(row)
    Student.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

# retrieve all the rows from the "Students" database
# remember each row should be a new instance of the Student class
  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).map { |row| new_from_db(row) }
  end

# find the student in the database given a name
# return a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL
    array_of_data = DB[:conn].execute(sql, name)[0]
    new_from_db(array_of_data)
  end

# called on object to save in the db
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

# returns an array of all students in grade 9
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = '9'
      SQL
    DB[:conn].execute(sql)
  end

# returns an array of all students in grades lower than 12
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < '12'
      SQL
    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(number_of_students_int)
    sql = <<-SQL
      SELECT *
      FROM students
      ORDER BY id
      LIMIT #{number_of_students_int}
      SQL
    DB[:conn].execute(sql)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY id
      LIMIT 1
      SQL
    db_info = DB[:conn].execute(sql)[0]
    new_from_db(db_info)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = '#{grade}'
      SQL
    DB[:conn].execute(sql)
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
