class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student  # return the newly created instance
  end # create a new Student object given a row from the database
  


  def self.all
    sql = <<-SQL
      SELECT *
      FROM songs
    SQL
 
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end# retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end# find the student in the database given a name
    # return a new instance of the Student class
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9 
    SQL
 
    grade_9_array = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    grade_9_array

  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade <= 11 
    SQL
 
    grades_below_11_array = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    grades_below_11_array

  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
 
    all_students_array = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    all_students_array

  end

  def self.first_x_students_in_grade_10(limit)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT (?)
    SQL
 
    all_students_grade_x = DB[:conn].execute(sql,limit).map do |row|
      self.new_from_db(row)
    end
    all_students_grade_x

  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      ORDER BY id
      ASC
      LIMIT 1

      
    SQL
 
    first_one_ten = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    first_one_ten.first

  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = (?)
      SQL
 
    all_grade_x = DB[:conn].execute(sql,grade).map do |row|
      self.new_from_db(row)
    end
    all_grade_x

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
