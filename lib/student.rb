class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students;").map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    DB[:conn].execute("SELECT * FROM students WHERE name = (?);", name).map {|row| self.new_from_db(row)}[0]
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
    DB[:conn].execute("SELECT COUNT(*) FROM students WHERE grade = 9;")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE grade < 12;").map {|row| self.new_from_db(row)}
  end

  def self.first_x_students_in_grade_10(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT (?);", x).map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    DB[:conn].execute("SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1;").map {|row| self.new_from_db(row)}[0]
  end

  def self.all_students_in_grade_X(x)
    DB[:conn].execute("SELECT * FROM students WHERE grade = (?);", x).map {|row| self.new_from_db(row)}
  end

end
