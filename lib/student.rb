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
    all_rows = DB[:conn].execute("SELECT * FROM students")
    all_rows.collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students 
    WHERE name = ?
    LIMIT 1
    SQL
    student_row = DB[:conn].execute(sql, name).first
    self.new_from_db(student_row)
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
    SELECT * FROM students 
    WHERE grade = 9
    SQL
    ninth_grade = DB[:conn].execute(sql)
    ninth_grade.map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    grades = DB[:conn].execute(sql)
    grades.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10 
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1
    SQL
    student = DB[:conn].execute(sql).first
    self.new_from_db(student)
  end
end
