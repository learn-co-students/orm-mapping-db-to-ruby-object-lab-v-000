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
    sql = <<-SQL
    SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
  end


  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade <= 11
    SQL
    DB[:conn].execute(sql)
  end
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL
    DB[:conn].execute(sql,grade).map { |row| new_from_db(row) }
  end

  def self.count_all_students_in_grade_9
    # sql = <<-SQL
    # SELECT COUNT(*) FROM students WHERE grade = 9
    # SQL
    # DB[:conn].execute(sql)
    self.all_students_in_grade_X("9")
  end

  def self.first_x_students_in_grade_10 (x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade =10 LIMIT ?
    SQL
    DB[:conn].execute(sql,x).map { |row| new_from_db(row) }
  end

  def self.first_student_in_grade_10
    first_x_students_in_grade_10(1).first
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
