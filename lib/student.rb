require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    DB[:conn].execute("SELECT id, name, grade FROM students;")
      .map { |row| new_from_db(row) }
  end

  def self.find_by_name(name)
    select = DB[:conn].prepare(
      "SELECT id, name, grade FROM students WHERE name = ?;"
    )
    row = select.execute(name).next
    select.execute("END;")
    new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT name FROM students WHERE grade = 9;")
      .map { |row| row[0] }
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT name FROM students WHERE grade < 12;")
      .map { |row| row[0] }
  end

  def self.first_X_students_in_grade_10(limit)
    select = DB[:conn].prepare(
      "SELECT name FROM students WHERE grade = 10 LIMIT ?;"
    )
    students = select.execute(limit).map { |row| row[0] }
    select.execute("END;")
    students
  end

  def self.first_student_in_grade_10
    row = DB[:conn].execute(
      "SELECT id, name, grade FROM students WHERE grade = 10 LIMIT 1;"
    )
    new_from_db(row[0])
  end

  def self.all_students_in_grade_X(grade)
    select = DB[:conn].prepare("SELECT name FROM students WHERE grade = ?;")
    students = select.execute(grade).map { |row| row[0] }
    select.execute("END;")
    students
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
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

end
