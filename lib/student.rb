class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new(:name => row[1] , :grade => row[2], :id => row[0])

  end

  def initialize (args = Hash.new)
    @name = args[:name] if args[:name]
    @grade = args[:grade] if args[:grade]
    @id = args[:id] if args[:id]
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM Students"
    all = []
    student_array = DB[:conn].execute(sql)
    student_array.each do |student|
      all <<  Student.new_from_db(student)
    end
    all
  end

  def self.first_x_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql,num)
  end

  def self.first_student_in_grade_10
    student = self.first_x_students_in_grade_10(1).first
    self.new_from_db(student)
  end

  def self.all_students_in_grade_X(grade=10)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql,grade)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * FROM Students WHERE Students.name = ? LIMIT 1"
    Student.new_from_db(DB[:conn].execute(sql,name)[0])
  end

  def save
    sql = "INSERT INTO students (name, grade) VALUES (?, ?)"

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students where grade < 12"
    DB[:conn].execute(sql)
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
