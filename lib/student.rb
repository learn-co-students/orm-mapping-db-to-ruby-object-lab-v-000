class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students").map {|student| self.new_from_db(student)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    self.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE students.name = ? LIMIT 1", name).first)
  end

  def self.count_all_students_in_grade_9
    DB[:conn].execute("SELECT COUNT(*) FROM students WHERE students.grade = 9")
  end

  def self.students_below_12th_grade
    DB[:conn].execute("SELECT * FROM students WHERE students.grade < 12").map{|student| self.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(count)
    DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT ?", count).map{|student| self.new_from_db(student)}
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(grade)
    DB[:conn].execute("SELECT * FROM students WHERE students.grade = ?", grade).map{|student| self.new_from_db(student)}
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
