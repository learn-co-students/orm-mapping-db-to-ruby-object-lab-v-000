require 'pry'


class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
    # create a new Student object given a row from the database
  end



    def self.find_by_name(name)
      sql = "SELECT * FROM students WHERE name = ?"
      DB[:conn].execute(sql, name).collect  {|row| self.new_from_db(row)}.first


    # binding.pry


    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end


  def self.count_all_students_in_grade_9
    self.all.select do |student|
      student.grade == "9"
      # binding.pry
    end
  end

  def self.students_below_12th_grade
    self.all.select do |student|
      student.grade < "12"
    end
  end

  def self.first_student_in_grade_10
    self.all.select {|student| student.grade == "10"}.first
  end

  def self.first_x_students_in_grade_10(x)
    self.all.select {|student| student.grade == "10"}.first(x)
  end


  def self.all_students_in_grade_X(x)
    self.all.select {|student| student.grade == "#{x}"}
  end

    # def self.all_students_in_grade_X(x)
    #   sql = <<-SQL
    #     SELECT * FROM students
    #     WHERE grade = ?
    #     SQL
    #     DB[:conn].execute(sql, x).collect do |row|
    #       self.new_from_db(row)
    #     end
    #
    # end



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
