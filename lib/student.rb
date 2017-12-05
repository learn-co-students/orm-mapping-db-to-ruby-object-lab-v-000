class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id, new_student.name, new_student.grade = row[0], row[1], row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    
    self.collect_from_db(sql)
  end
  
  def self.collect_from_db(sql, arg = nil)
    # Creates array of student objects from rows returned by executing sql on databse
    DB[:conn].execute(sql, arg).collect { |student_data| self.new_from_db(student_data) }
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ?
    SQL
    
    self.new_from_db(DB[:conn].execute(sql, name).flatten)
  end
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade = 9
    SQL
    
    self.collect_from_db(sql)
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL
    
    self.collect_from_db(sql)
  end
  
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    
    self.collect_from_db(sql, x)
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL
    
    self.new_from_db(DB[:conn].execute(sql).flatten)
  end
  
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL
    
    self.collect_from_db(sql, x)
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
