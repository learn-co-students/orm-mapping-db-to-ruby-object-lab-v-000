class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    
    rows = DB[:conn].execute(sql)
    self.map_rows(rows)
  end
  
  def self.map_rows(rows)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name=?
    SQL
    
    row = DB[:conn].execute(sql, name)
    self.new_from_db(row[0])
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = '9'
    SQL
    
    rows = DB[:conn].execute(sql)
    self.map_rows(rows)
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL
    
    rows = DB[:conn].execute(sql)
    self.map_rows(rows)
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
  
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    
    rows = DB[:conn].execute(sql, x)
    self.map_rows(rows)
  end
  
  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end
  
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL
    
    rows = DB[:conn].execute(sql, x)
    self.map_rows(rows)
  end
end
