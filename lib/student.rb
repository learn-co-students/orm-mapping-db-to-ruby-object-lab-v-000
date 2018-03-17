class Student
  attr_accessor :id, :name, :grade
  attr_reader :all
  @@all = []

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students;
    SQL
    array = DB[:conn].execute(sql)
    array.each do |row|
      @@all << self.new_from_db(row)
    end
    @@all
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*) FROM students
      WHERE grade = 9;
    SQL

    execute = DB[:conn].execute(sql)

  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12;
    SQL

    execute = DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(number_of_students)
    sql = <<-SQL
      SELECT * FROM students
      LIMIT ?;
    SQL

    execute = DB[:conn].execute(sql, number_of_students)
  end

  def self.first_student_in_grade_10
    # sql = <<-SQL
    #   SELECT * FROM students
    #   WHERE grade = 10
    #   LIMIT 1;
    # SQL

    # name = DB[:conn].execute(sql)[0][1]
    self.all.detect {|instance| instance.grade == "10"}
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?;
    SQL

    execute = DB[:conn].execute(sql, grade)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?;
    SQL
    student_array = DB[:conn].execute(sql, name)[0]
    new_student = Student.new
    new_student.name = student_array[1]
    new_student.id = student_array[0]
    new_student.grade = student_array[2]
    new_student
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

# test = Student.new
# test.name = "test"
# test.grade = "test"
# test.all


