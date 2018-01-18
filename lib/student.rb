require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new()
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    sql = <<-SQL
      SELECT * FROM Students;
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM Students
      WHERE name = ?;
    SQL

    rows = DB[:conn].execute(sql,name)
    self.new_from_db(rows.first)
    # find the student in the database given a name
    # return a new instance of the Student class
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
    self.all.find_all do |student|
      student.grade == "9"
    end
  end

  def self.students_below_12th_grade
    self.all.find_all { |student|
      student.grade != "12"
    }
  end

  def self.first_x_students_in_grade_10(x)
    outs = self.all.find_all do |student|
      student.grade == "10"
    end
    outs.first(x)
  end

  def self.first_student_in_grade_10
    self.all.find_all do |student|
      student.grade == "10"
    end.first
  end

  def self.all_students_in_grade_x(x)
    self.all.find_all do |student|
      student.grade == x.to_s
    end
  end

end
