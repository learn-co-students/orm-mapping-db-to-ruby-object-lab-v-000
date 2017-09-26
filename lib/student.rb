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
    sql = 'SELECT * FROM students'
    all_rows = DB[:conn].execute(sql)
    all_rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = 'SELECT * FROM students WHERE name = ?'
    row = DB[:conn].execute(sql,name)[0]
    self.new_from_db(row)
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

  def self.first_x_students_in_grade_10(x)
    sql = 'SELECT * FROM students WHERE grade = ? ORDER BY students.id ASC LIMIT ?'
    rows = DB[:conn].execute(sql,10,x)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    self.first_x_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_x(x)
    sql = 'SELECT * FROM students WHERE grade = ?'
    rows = DB[:conn].execute(sql,x)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.count_all_students_in_grade_9
    sql = 'SELECT * FROM students WHERE grade = ?'
    rows = DB[:conn].execute(sql,9)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = 'SELECT * FROM students WHERE grade < ?'
    rows = DB[:conn].execute(sql,12)
    rows.map do |row|
      self.new_from_db(row)
    end
  end        

end
