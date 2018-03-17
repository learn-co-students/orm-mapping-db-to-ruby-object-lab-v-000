class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
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
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    students_in_grade_9 = []
    DB[:conn].execute(sql).map do |row|
      students_in_grade_9 << self.new_from_db(row)
    end
    students_in_grade_9
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    students_below_12th_grade = []
    DB[:conn].execute(sql).map do |row|
      students_below_12th_grade << self.new_from_db(row)
    end
    students_below_12th_grade
  end

  def self.first_x_students_in_grade_10(number)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
    SQL

    first_x_students_in_grade_10 = []
    DB[:conn].execute(sql).map do |row|
      first_x_students_in_grade_10 << self.new_from_db(row)
    end
    first_x_students_in_grade_10.take(number)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
         self.new_from_db(row)
       end.first
  end

  def self.all_students_in_grade_X(grade_x)
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    all_students_in_grade_x = []
    DB[:conn].execute(sql).map do |row|
      if row[2] = grade_x
         all_students_in_grade_x << self.new_from_db(row)
      end
    end
       all_students_in_grade_x
  end
end
