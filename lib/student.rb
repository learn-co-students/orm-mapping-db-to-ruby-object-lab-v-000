class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map { |row|
      self.new_from_db(row)
    }
  end

  def self.find_by_name(name)
    student_info = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    student = self.new_from_db(student_info)
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
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT * FROM students WHERE grade = '9'").collect{ |row|
    self.new_from_db(row) }
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade IS NOT '12'").collect{ |row|
    self.new_from_db(row) }
  end

  def self.first_x_students_in_grade_10(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = '10' LIMIT ?", x).collect{ |row|
    self.new_from_db(row) }
  end

  def self.first_student_in_grade_10
    DB[:conn].execute("SELECT * FROM students WHERE grade = '10' ORDER BY id ASC LIMIT 1").collect{ |row|
    self.new_from_db(row) }.first
  end

  def self.all_students_in_grade_x(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x).collect{ |row|
    self.new_from_db(row) }
  end

end
