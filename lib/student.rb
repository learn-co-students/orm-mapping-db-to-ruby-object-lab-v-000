class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    all_sql = <<-SQL
    SELECT * FROM students
    SQL
    DB[:conn].execute(all_sql).collect  do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    find_name_sql = <<-SQL
    SELECT * FROM students
    WHERE name = ? LIMIT 1
    SQL
    DB[:conn].execute(find_name_sql, name).collect do |row|
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
    grade_9_sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 9
    SQL
    DB[:conn].execute(grade_9_sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    below_12_sql = <<-SQL
    SELECT * FROM students
    WHERE grade <= 11
    SQL
    DB[:conn].execute(below_12_sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x_students)
    x_students_sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?
    SQL
    DB[:conn].execute(x_students_sql, x_students).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    first_in_10_sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    SQL
    DB[:conn].execute(first_in_10_sql).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade_x)
    grade_x_sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    DB[:conn].execute(grade_x_sql, grade_x).collect do |row|
      self.new_from_db(row)
    end
  end

end
