require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
            SELECT * FROM students
             SQL
    DB[:conn].execute(sql).map do |row|
          self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
            SELECT * FROM students where name = ? LIMIT 1
            SQL
    DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
    end.first
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


  def self.count_all_students_in_grade_9
    sql = <<-SQL
            SELECT COUNT(NAME) FROM students WHERE grade = 9
             SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
            SELECT * FROM students WHERE grade < 12
             SQL
    DB[:conn].execute(sql).map { |row|
        self.new_from_db(row)
     }
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
            SELECT * FROM students where grade = 10 LIMIT ?
            SQL
    DB[:conn].execute(sql, num).map do |row|
        self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
            SELECT * FROM students where grade = 10
            SQL
    DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(what_grade)
    sql = <<-SQL
            SELECT * FROM students where grade = ?
            SQL
    DB[:conn].execute(sql, what_grade).map do |row|
        self.new_from_db(row)
    end
  end

end
