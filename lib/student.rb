class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil, name=nil, grade=nil)
    @id = id
    @name = name
    @grade = grade
  end 

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end
  
  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = ?"
    students = DB[:conn].execute(sql, 9)
    students.collect do |s|
      self.new(s[0], s[1], s[2])
    end
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < ?"
    students = DB[:conn].execute(sql, 12)
    students.collect do |s|
      self.new(s[0], s[1], s[2])
    end
  end 

  def self.first_X_students_in_grade_10(x)
    sql = "SELECT * FROM students WHERE grade = ? LIMIT ?"
    students = DB[:conn].execute(sql, 10, x)
    students.collect do |s|
      self.new(s[0], s[1], s[2])
    end
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = ?"
    students = DB[:conn].execute(sql, 10)
    students.collect do |s|
      self.new(s[0], s[1], s[2])
    end.first
  end 

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    students = DB[:conn].execute(sql, x)
    students.collect do |s|
      self.new(s[0], s[1], s[2])
    end
  end 

  def self.all
    sql = "SELECT * FROM students"
    students = DB[:conn].execute(sql)
    students.collect do |s|
      self.new(s[0], s[1], s[2])
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    student = DB[:conn].execute(sql, name).flatten
    self.new(student[0], student[1], student[2])
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
