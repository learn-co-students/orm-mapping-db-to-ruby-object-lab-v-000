require 'pry'
class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def self.new_from_db(row)
    o = self.new
    o.id = row[0]
    o.name = row[1]
    o.grade = row[2]
    @@all << o
    o
  end

  def self.all
    all = DB[:conn].execute("SELECT * FROM students")
    students = []
    all.each {|row| students << new_from_db(row)}
    students
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    student = new_from_db(row)
    student
  end

  def self.count_all_students_in_grade_9
    students = all.select { |s| s.grade == "9"}
    students
  end

  def self.students_below_12th_grade
    students = all.select { |s| s.grade.to_i < 12}
    students
  end

  def self.first_X_students_in_grade_10(num)
    all = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", num)
    students = []
    all.each {|row| students << new_from_db(row)}
    students
  end

  def self.first_student_in_grade_10
    all.detect { |s| s.grade == "10"}
  end

  def self.all_students_in_grade_X(grd)
    all.select { |s| s.grade.to_i == grd}
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
