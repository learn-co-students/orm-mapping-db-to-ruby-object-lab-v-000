class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id, student.name, student.grade = row[0], row[1], row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    
    table = DB[:conn].execute(sql)
    students = table.collect {|row| new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name == (?)
    SQL
    
    row = DB[:conn].execute(sql, name)
    
    student = new_from_db(row[0])
    student
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
  
  def self.count_all_students_in_grade_9
    all.select {|student| student.grade == "9"}
  end
  
  def self.students_below_12th_grade
    all.select {|student| student.grade.to_i < 12}
  end
  
  def self.first_X_students_in_grade_10(x)
    all.select.first(x) {|student| student.grade == "10"}
  end
  
  def self.first_student_in_grade_10
    tenth_grade = all.select {|student| student.grade == "10"}
    tenth_grade.first
  end
  
  def self.all_students_in_grade_X(x)
    all.select {|student| student.grade.to_i == x}
  end
end
