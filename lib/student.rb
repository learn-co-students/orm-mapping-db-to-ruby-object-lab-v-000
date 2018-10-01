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
    # remember each row should be a new instance of the Student class
     sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |student_attributes|
      new_from_db(student_attributes)
    end 
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
   sql = "SELECT * FROM students WHERE name = ?"
   result = DB[:conn].execute(sql,name)
   new_from_db(result[0])
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
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql,9).map do |return_array|
      new_from_db(return_array)
    end 
  end 
  
  def self.students_below_12th_grade 
    sql = "SELECT * FROM students WHERE grade < ?"
    DB[:conn].execute(sql,12).map do |return_array|
      new_from_db(return_array)
    end 
  end 
  
  def self.first_X_students_in_grade_10(number)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql,number).map do |return_array|
      new_from_db(return_array)
    end 
  end 
  
  def self.first_student_in_grade_10 
    first_X_students_in_grade_10(1)[0]
  end 
  
  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql,grade).map do |return_array|
      new_from_db(return_array)
    end 
  end 
  
end
