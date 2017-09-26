class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    self.new_from_db(DB[:conn].execute(sql, name).first)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.first_x_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, x).map { |row| self.new_from_db(row) }
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1"
    self.new_from_db(DB[:conn].execute(sql).first)
  end

  def self.all_students_in_grade_x(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, x).map { |row| self.new_from_db(row) }
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

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

end
