#Question: What are the downsides to creating a class variable @@all and filling it with instances of the database? What if the database changes, i.e.,
#the students ascend a grade or graduate? The student will still have an instance in the @@all variable yet it will be wrong, which will require a new
#method to deal with those that graduate or ascend a grade. Hmm...

#Doing it the way the test is built is advantageous. It draws data when it NEEDS to. Lul, we just need a .clear method. ^^

class Student
  attr_accessor :id, :name, :grade

  @@all = []

  def initialize(id = nil, name = nil, grade = nil)
    @id = id
    @name = name
    @grade = grade
    @@all << self
  end

  def self.clear
    @@all.clear
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new(row[0], row[1], row[2])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    @@all
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

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = "9"
      SQL

    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
      SQL

    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = "10"
      LIMIT ?
      SQL

    DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = "10"
      LIMIT 1
      SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      SQL

    DB[:conn].execute(sql, x)
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
