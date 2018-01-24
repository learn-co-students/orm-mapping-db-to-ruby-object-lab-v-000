require 'pry'

class Student
  attr_accessor :id, :name, :grade

  #create a new Student object given a row from the database
  def self.new_from_db(row)
    student = self.new()

    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  # retrieve all the rows from the "Students" database and creates new objects out of them in an array.
  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    DB[:conn].execute(sql).collect do |row|  #DB[:conn].execute(sql).map do {|row| self.new_from_db(row)}
      self.new_from_db(row)
    end
  end

  # find the student in the database given a name, returning a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
         SELECT * FROM students
         WHERE name = ?
         /*LIMIT 1 */
         SQL

    DB[:conn].execute(sql, name).collect do |row|
      self.new_from_db(row)
    end.first #ensures function returns first (in this case, only) object in collected array instead of the array itself. end[0] achieves same result.
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
        SELECT * FROM students WHERE grade = "9"
        SQL

    DB[:conn].execute(sql).collect {|row| self.new_from_db(row)}
  end


  def self.first_student_in_grade_10
    sql = <<-SQL
        SELECT * FROM students WHERE grade = "10" LIMIT 1
        SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first #needed longform of collect to call .first on end
  end


  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
        SELECT * FROM students WHERE grade = "10" LIMIT ?
        SQL

    DB[:conn].execute(sql, x).collect {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT * FROM students WHERE grade < "12"
        SQL
    DB[:conn].execute(sql).collect {|row| self.new_from_db(row)}
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
        SELECT * FROM students WHERE grade = ?
        SQL
    DB[:conn].execute(sql, x).map {|row| self.new_from_db(row)}
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
