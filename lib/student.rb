class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students").map { |student|
      @@all << self.new_from_db(student)
    }
    @@all
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name=? LIMIT 1", name)
    self.new_from_db(row[0])
  end

  def self.first_X_students_in_grade_10(num)
    DB[:conn].execute("SELECT * FROM students WHERE grade=10 LIMIT ?", num)
  end

  def self.first_student_in_grade_10
    first_student = DB[:conn].execute("SELECT * FROM students WHERE grade=10 LIMIT 1")[0]
    self.new_from_db(first_student)
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT COUNT(*) FROM students WHERE grade=9")[0].flatten
  end

  def self.all_students_in_grade_X(grade)
    DB[:conn].execute("SELECT * FROM students WHERE grade=?", grade)
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE CAST(grade AS INTEGER) < 12")
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
