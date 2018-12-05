class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    
    self.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    
    sql = "SELECT * FROM students"
    
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE name = ?
      LIMIT 1
    SQL
    
    self.new_from_db( DB[:conn].execute(sql, name).first )
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
    # This works as well: self.all.select {|student| student.grade == "9"}
    
    sql = "SELECT * FROM students WHERE grade = 9"
    
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def self.students_below_12th_grade
    # Equivalently: self.all.select {|student| student.grade.to_i < 12}
    
    sql = "SELECT * FROM students WHERE grade < 12"
    
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_X_students_in_grade_10(number_of_students)
    # Equivalently: 
    # self.all.select {|student| student.grade == "10"}.slice(0, number_of_students)
    
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade = 10 
      LIMIT ?
    SQL
    
    DB[:conn].execute(sql, number_of_students).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_student_in_grade_10
    # Equivalently: self.all.select {|student| student.grade == "10"}.first
    # Or: self.first_X_students_in_grade_10(1).first
    
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade = 10 
      LIMIT 1
    SQL
    
    self.new_from_db( DB[:conn].execute(sql).first )
  end
  
  def self.all_students_in_grade_X(grade_X)
    # Equivalently: self.all.select {|student| student.grade.to_i == grade_X}
    
    sql = "SELECT * FROM students WHERE grade = ?"
    
    DB[:conn].execute(sql, grade_X).collect {|row| self.new_from_db(row)}
  end
end
