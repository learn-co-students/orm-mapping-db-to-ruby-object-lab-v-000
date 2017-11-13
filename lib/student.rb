class Student
  attr_accessor :id, :name, :grade

  def initialize(id: nil, name: nil, grade: nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    Student.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end

  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    array = DB[:conn].execute(sql)
    array.map{|student| self.new_from_db(student)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
      SQL

    row = DB[:conn].execute(sql, name).first
    self.new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 9
      SQL

    array = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
      SQL

    array = DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
      SQL

    array = DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
      SQL

    row = DB[:conn].execute(sql).first
    self.new_from_db(row)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
      SQL

    array = DB[:conn].execute(sql, x)
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
