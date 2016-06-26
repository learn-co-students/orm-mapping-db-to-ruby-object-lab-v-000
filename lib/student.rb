class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(record)
    # create a new Student object given a record from the database
    self.new.tap do |x|
      # x.id = record[0]
      # x.name = record[1]
      # x.grade = record[2]
      x.id, x.name, x.grade = record
    end
  end

  def self.all
    # retrieve all the records from the "Students" database
    # remember each record should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |record|
      self.new_from_db(record)
    end
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

    DB[:conn].execute(sql, name).map do |record|
      self.new_from_db(record)
    end.first
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*)
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).first
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT COUNT(*)
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).first
  end

  def self.first_x_students_in_grade_10(number_of_students)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(sql, number_of_students).map do |record|
      self.new_from_db(record)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |record|
      self.new_from_db(record)
    end.first
  end

  def self.all_students_in_grade_X(number_of_students)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, number_of_students).map do |record|
      self.new_from_db(record)
    end
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
