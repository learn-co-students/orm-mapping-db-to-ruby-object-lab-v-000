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
    DB[:conn].execute("SELECT * FROM students").map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
            SELECT * FROM students
            WHERE name=?
            LIMIT 1;
            SQL
    self.collect_students(sql, name).first
  end
  
  
  
  def self.find_by_grade(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade=?
      SQL
    self.collect_students(sql, grade)
  end

  
  def self.count_all_students_in_grade_9
    find_by_grade(9)
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade<?
      SQL
    self.collect_students(sql, 12)
  end
  
  def self.first_student_in_grade_10
    find_by_grade(10).first
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
  
  private 
  def self.collect_students(sql, arg)
    DB[:conn].execute(sql, arg).map do |row|
      self.new_from_db(row)
    end
  end
end
