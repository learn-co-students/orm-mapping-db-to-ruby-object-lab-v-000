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
    sql = <<-sql
      SELECT * FROM students
    sql

    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-sql
      SELECT * FROM students WHERE name = ? LIMIT 1
    sql

    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
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
    sql = <<-sql
      SELECT * FROM students WHERE grade = 9
    sql

    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-sql
      SELECT * FROM students WHERE grade != 12
    sql

    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.first_x_students_in_grade_10(number)
    sql = <<-sql
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    sql

    DB[:conn].execute(sql, number).map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-sql
      SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1
    sql

    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-sql
      SELECT * FROM students WHERE grade = ?
    sql

    DB[:conn].execute(sql, grade).map {|row| self.new_from_db(row)}
  end
end
