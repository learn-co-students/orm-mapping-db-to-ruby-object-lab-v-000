class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_kid =       self.new
    new_kid.id =    row[0]
    new_kid.name =  row[1]
    new_kid.grade = row[2]
    new_kid
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE students.name = ? LIMIT 1
    SQL
    
    DB[:conn].execute(sql, name).map do |row|
    self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL
    
    DB[:conn].execute(sql, 9)
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade < ?
    SQL
    
    DB[:conn].execute(sql, 12).map do |row|
    self.new_from_db(row)
    end
  end
  
  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ? LIMIT ?
    SQL
    
    DB[:conn].execute(sql, 10, num)
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = 10 LIMIT 1 
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE students.grade = ?
    SQL
    
    DB[:conn].execute(sql, grade)
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
