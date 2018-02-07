class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id, new_student.name, new_student.grade = row[0], row[1], row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).collect do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    DB[:conn].execute(sql, name).collect do |student|
      self.new_from_db(student)
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
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, 9).collect do |student|
      self.new_from_db(student)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < ?
    SQL
    DB[:conn].execute(sql, 12).collect do |student|
      self.new_from_db(student)
    end
  end

  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, 10).collect do |student|
      self.new_from_db(student)
    end[0..number-1]
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, 10).collect do |student|
      self.new_from_db(student)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql, grade).collect do |student|
      self.new_from_db(student)
    end
  end

end
