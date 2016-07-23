class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.name = row[1]
    student.grade = row[2]
    student.id = row[0]
    student
  end

  def self.all
    students_array = []
    sql = "SELECT * FROM students;"
    DB[:conn].execute(sql).each{|student| students_array << new_from_db(student)}
    students_array
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = (?) LIMIT 1;"
    new_from_db(DB[:conn].execute(sql, name).first)
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
    students_array = []
    sql = "SELECT * FROM students WHERE grade = 9;"
    DB[:conn].execute(sql).each{|student| students_array << new_from_db(student)}
    students_array
  end

  def self.students_below_12th_grade
    students_array = []
    sql = "SELECT * FROM students WHERE grade < 12;"
    DB[:conn].execute(sql).each{|student| students_array << new_from_db(student)}
    students_array
  end

  def self.first_x_students_in_grade_10(x)
    students_array = []
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?;"
    DB[:conn].execute(sql, x).each{|student| students_array << new_from_db(student)}
    students_array
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1;"
    new_from_db(DB[:conn].execute(sql).first)
  end

  def self.all_students_in_grade_X(x)
    students_array = []
    sql = "SELECT * FROM students WHERE grade = ?;"
    DB[:conn].execute(sql, x).each{|student| students_array << new_from_db(student)}
    students_array
  end
end
