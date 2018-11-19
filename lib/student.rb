class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
        SELECT * FROM students
        SQL
    
    # remember each row should be a new instance of the Student class    
    DB[:conn].execute(sql).map{|row| Student.new_from_db(row)}
    
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = <<-SQL
        SELECT * FROM students
        WHERE name = ?
        LIMIT 1
        SQL
    
    # return a new instance of the Student class
    DB[:conn].execute(sql, name).map{|row| Student.new_from_db(row)}.first
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
  
  def self.all_students_in_grade_9
    sql = <<-SQL
        SELECT * FROM students
        WHERE grade = 9
        SQL
    
    DB[:conn].execute(sql).map{|row| Student.new_from_db(row)}
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT * FROM students
        WHERE grade < 12
        SQL
    
    DB[:conn].execute(sql).map{|row| Student.new_from_db(row)}
  end
  
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
        SELECT * FROM students
        WHERE grade = 10 
        ORDER BY id
        LIMIT ?
        SQL
    
    DB[:conn].execute(sql, x).map{|row| Student.new_from_db(row)}
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
        SELECT * FROM students
        WHERE grade = 10 
        ORDER BY id
        LIMIT 1
        SQL
    
    DB[:conn].execute(sql).map{|row| Student.new_from_db(row)}.first
  end
  
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
        SELECT * FROM students
        WHERE grade = ? 
        SQL
    
    DB[:conn].execute(sql, x).map{|row| Student.new_from_db(row)}
  end  
end
