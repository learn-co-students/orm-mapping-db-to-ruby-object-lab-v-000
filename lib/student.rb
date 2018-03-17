class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
  new_student = self.new
  new_student.id = row[0]
  new_student.name =  row[1]
  new_student.grade = row[2]
  new_student  # return the newly created instance
  end

  def self.all
     sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end
  end

  def self.find_by_name(name)
   sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    row = DB[:conn].execute(sql, name)
     self.new_from_db(row[0])
    # find the student in the database given a name
    # return a new instance of the Student class
    end

  def save
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    array_grade9 = []
    sql = "SELECT name FROM students WHERE grade = 9"
      DB[:conn].execute(sql).map do |row|
      array_grade9 << self.new_from_db(row)
      end
    array_grade9
  end

   def self.students_below_12th_grade
    array_grade12 = []
    sql = "SELECT name FROM students WHERE grade < 12"
      DB[:conn].execute(sql).map do |row|
      array_grade12 << self.new_from_db(row)
      end
    array_grade12
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
      row = DB[:conn].execute(sql)
    self.new_from_db(row[0])
  end

  def self.all_students_in_grade_X
     array_gradeX = []
    sql = "SELECT * FROM students WHERE grade = 10"
      DB[:conn].execute(sql).map do |row|
      array_gradeX << self.new_from_db(row)
      end
    array_gradeX
  end

  def self.first_x_students_in_grade_10(l)
     array_gradeX = []
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
      DB[:conn].execute(sql, l).map do |row|
      array_gradeX << self.new_from_db(row)
      end
    array_gradeX
  end

end
