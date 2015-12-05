require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(csv_row)
    student = self.new
    student.id = csv_row[0]
    student.name = csv_row[1]
    student.grade = csv_row[2]
    student
  end

  def self.all
    sql = <<-sql
      SELECT * 
      FROM students;
    sql
    find = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-sql
      SELECT * 
      FROM students
      WHERE name = ?
      LIMIT 1;
    sql
    find = DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.students_below_12th_grade
    sql = <<-sql
      SELECT * 
      FROM students
      WHERE grade < 12;
    sql
    find = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_12
    sql = <<-sql
      SELECT * 
      FROM students
      WHERE grade = 12;
    sql
    find = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.count_all_students_in_grade_9
    sql = <<-sql
      SELECT * 
      FROM students
      WHERE grade = 9;
    sql
    find = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
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
