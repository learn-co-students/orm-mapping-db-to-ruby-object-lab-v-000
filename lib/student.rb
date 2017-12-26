class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def initialize(id=nil, name=nil, grade=nil)
    @id = id
    @name = name
    @grade = grade
    @@all << []
  end

  def self.new_from_db(row)
    student_new = self.new(row[0], row[1], row[2])
    # create a new Student object given a row from the database
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
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
    DB[:conn].execute(sql, name).map do |student|
      self.new_from_db(student)
    end.first

  end

  def self.count_all_students_in_grade_9
    sql = "SELECT name FROM students WHERE grade = 9"
    DB[:conn].execute(sql).flatten[0]
  end

  def self.students_below_12th_grade
    sql = "SELECT name FROM students WHERE grade < 12"
    DB[:conn].execute(sql).flatten[0]
end

  def self.first_X_students_in_grade_10(number)
    sql = "SELECT name FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, number).flatten
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    student = self.new_from_db(DB[:conn].execute(sql).flatten)
    student
  end

  def self.all_students_in_grade_X(number)
    sql = "SELECT name FROM students WHERE grade = ?"
    DB[:conn].execute(sql, number).flatten
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
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
