class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = "SELECT * FROM students"

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE students.name = ?
    SQL

    DB[:conn].execute(sql, name).map do |student|
      self.new_from_db(student)
    end.first
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE students.grade = 9"

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE students.grade < 12"

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE students.grade = 10"

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end.first
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
