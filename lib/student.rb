class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
Student.new(name, grade)
  end

  def self.all
    'SELECT * FROM students;'
  end

  def self.find_by_name(name)
    'SELECT name FROM students WHERE name = name;'
    return Student.new
  end

  def self.all_students_in_grade_9
    'SELECT * FROM students WHERE GRADE = 9;'
  end

  def self.students_below_12th_grade
    'SELECT * FROM students WHERE GRADE < 12;'
  end

  def self.first_X_students_in_grade_10(student_count)
    'SELECT TOP 10 grade FROM students WHERE GRADE = 10;'
  end

  def self.first_student_in_grade_10
    'SELECT grade FROM students WHERE GRADE = 10 DESC LIMIT 1;'
  end

  def self.all_students_in_grade_X(grade)
    'SELECT grade FROM students WHERE grade = NULL'
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
